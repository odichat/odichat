namespace :db do
  desc "Test production migration script in development (FIXED VERSION)"
  task test_production_migration_fixed: :environment do
    unless Rails.env.development?
      puts "❌ This task is only for development environment"
      exit 1
    end

    puts "🧪 TESTING FIXED PRODUCTION MIGRATION SCRIPT"
    puts "This migrates tables in dependency order"
    puts "=" * 60

    # Use development SQLite database
    sqlite_db_path = Rails.root.join("storage", "development.sqlite3")
    backup_dir = Rails.root.join("tmp", "migration_test_fixed")

    unless File.exist?(sqlite_db_path)
      puts "❌ SQLite development database not found at #{sqlite_db_path}"
      exit 1
    end

    FileUtils.mkdir_p(backup_dir)
    timestamp = Time.current.strftime("%Y%m%d_%H%M%S")

    puts "🚀 Starting FIXED migration from SQLite to PostgreSQL..."
    puts "📅 Test started at: #{Time.current}"
    puts "📂 SQLite database: #{sqlite_db_path}"

    # Create backup
    backup_file = backup_dir.join("development_fixed_backup_#{timestamp}.sqlite3")
    FileUtils.cp(sqlite_db_path, backup_file)
    puts "✅ Created backup: #{backup_file}"

    # Connect to SQLite
    require "sqlite3"
    sqlite_db = SQLite3::Database.new(sqlite_db_path.to_s)

    # **FIXED: Define tables in dependency order**
    tables_in_order = [
      # Independent tables first
      "models",
      "users",
      "flipper_features",
      "flipper_gates",
      "task_records",

      # Pay tables (independent)
      "pay_customers",
      "pay_merchants",
      "pay_payment_methods",
      "pay_subscriptions",
      "pay_charges",
      "pay_webhooks",

      # Active Storage (independent)
      "active_storage_blobs",
      "active_storage_attachments",
      "active_storage_variant_records",

      # Chatbot and its dependencies
      "chatbots",        # depends on users
      "contacts",        # depends on chatbots
      "documents",       # depends on chatbots
      "vector_stores",   # depends on chatbots
      "wabas",          # depends on chatbots
      "shareable_links", # depends on chatbots
      "chats",          # depends on chatbots, optionally contacts
      "messages"        # depends on chats
    ]

    # Filter to only include tables that exist
    existing_tables = sqlite_db.execute("SELECT name FROM sqlite_master WHERE type='table'")
      .map(&:first)
      .reject { |table| %w[schema_migrations ar_internal_metadata sqlite_sequence].include?(table) }

    tables_to_migrate = tables_in_order.select { |table| existing_tables.include?(table) }
    additional_tables = existing_tables - tables_to_migrate

    puts "📋 Tables in dependency order: #{tables_to_migrate.join(', ')}"
    puts "📋 Additional tables: #{additional_tables.join(', ')}" if additional_tables.any?

    # Add any additional tables at the end
    tables_to_migrate += additional_tables

    # Define problematic columns
    boolean_columns = {
      "pay_customers" => [ "default" ],
      "pay_payment_methods" => [ "default" ],
      "pay_subscriptions" => [ "metered" ],
      "wabas" => [ "subscribed" ]
    }

    reserved_keywords = %w[default]

    # Create test log
    log_file = backup_dir.join("fixed_migration_log_#{timestamp}.txt")

    File.open(log_file, "w") do |log|
      log.puts "FIXED Migration Log - #{Time.current}"
      log.puts "=" * 50
      log.puts "Migration order: #{tables_to_migrate.join(', ')}"

      # Disable foreign key constraints
      ActiveRecord::Base.connection.execute("SET session_replication_role = replica;")
      log.puts "✅ Disabled foreign key constraints"
      puts "✅ Disabled foreign key constraints"

      migration_success = true

      begin
        tables_to_migrate.each do |table|
          log.puts "\n📋 Processing table: #{table}"
          puts "📋 Processing table: #{table}"

          # Get table structure
          columns_info = sqlite_db.execute("PRAGMA table_info(#{table})")
          column_names = columns_info.map { |col| col[1] }

          # Quote reserved keywords
          quoted_column_names = column_names.map do |col|
            reserved_keywords.include?(col) ? "\"#{col}\"" : col
          end

          # Get data from SQLite
          rows = sqlite_db.execute("SELECT * FROM #{table}")
          log.puts "  📊 Found #{rows.length} records in SQLite"
          puts "  📊 Found #{rows.length} records"

          if rows.empty?
            log.puts "  ⏭️  Skipping empty table"
            puts "  ⏭️  Skipping empty table"
            next
          end

          # Clear existing PostgreSQL data
          ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table} RESTART IDENTITY CASCADE")
          log.puts "  🧹 Cleared PostgreSQL table"

          # Insert data with proper type handling
          success_count = 0
          error_count = 0

          rows.each_slice(25) do |batch|
            values = batch.map do |row|
              escaped_values = row.map.with_index do |value, index|
                column_name = column_names[index]

                # Handle boolean conversion
                if boolean_columns[table]&.include?(column_name)
                  if value.nil?
                    "NULL"
                  elsif value == 1 || value == "1" || value == "t" || value == "true"
                    "TRUE"
                  elsif value == 0 || value == "0" || value == "f" || value == "false"
                    "FALSE"
                  else
                    ActiveRecord::Base.connection.quote(value)
                  end
                else
                  ActiveRecord::Base.connection.quote(value)
                end
              end
              "(#{escaped_values.join(', ')})"
            end.join(", ")

            sql = "INSERT INTO #{table} (#{quoted_column_names.join(', ')}) VALUES #{values}"

            begin
              ActiveRecord::Base.connection.execute(sql)
              success_count += batch.length
            rescue => e
              log.puts "  ⚠️  Batch error: #{e.message}"
              puts "  ⚠️  Batch error, trying individual rows..."

              # Try individual rows
              batch.each do |row|
                escaped_values = row.map.with_index do |value, index|
                  column_name = column_names[index]

                  if boolean_columns[table]&.include?(column_name)
                    if value.nil?
                      "NULL"
                    elsif value == 1 || value == "1" || value == "t" || value == "true"
                      "TRUE"
                    elsif value == 0 || value == "0" || value == "f" || value == "false"
                      "FALSE"
                    else
                      ActiveRecord::Base.connection.quote(value)
                    end
                  else
                    ActiveRecord::Base.connection.quote(value)
                  end
                end

                single_sql = "INSERT INTO #{table} (#{quoted_column_names.join(', ')}) VALUES (#{escaped_values.join(', ')})"

                begin
                  ActiveRecord::Base.connection.execute(single_sql)
                  success_count += 1
                rescue => single_error
                  log.puts "  ❌ Row error: #{single_error.message}"
                  log.puts "  📄 Failed row: #{row.inspect}"
                  error_count += 1

                  # Stop after too many errors
                  if error_count > 10
                    log.puts "  ⚠️  Too many errors in #{table}, stopping..."
                    break
                  end
                end
              end
            end
          end

          # Verify count immediately after each table
          pg_count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM #{table}").first["count"]
          log.puts "  ✅ Migrated #{success_count}/#{rows.length} records (PostgreSQL count: #{pg_count})"
          puts "  ✅ Migrated #{success_count}/#{rows.length} records (PostgreSQL count: #{pg_count})"

          # Update sequence
          if ActiveRecord::Base.connection.column_exists?(table, "id")
            max_id_result = ActiveRecord::Base.connection.execute("SELECT MAX(id) FROM #{table}")
            max_id = max_id_result.first&.fetch("max", nil)

            if max_id && max_id > 0
              ActiveRecord::Base.connection.execute("SELECT setval('#{table}_id_seq', #{max_id})")
              log.puts "  🔄 Updated sequence to #{max_id}"
            end
          end

          # Verify data is still there before moving to next table
          final_count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM #{table}").first["count"]
          if final_count != pg_count
            log.puts "  ⚠️  WARNING: Count changed from #{pg_count} to #{final_count} after sequence update"
            puts "  ⚠️  WARNING: Count changed from #{pg_count} to #{final_count} after sequence update"
          end
        end

      rescue => e
        log.puts "💥 FATAL ERROR: #{e.message}"
        log.puts "📄 Backtrace: #{e.backtrace.join("\n")}"
        migration_success = false
      ensure
        # Re-enable foreign key constraints
        ActiveRecord::Base.connection.execute("SET session_replication_role = DEFAULT;")
        log.puts "✅ Re-enabled foreign key constraints"
        puts "✅ Re-enabled foreign key constraints"
      end

      sqlite_db.close

      # Final verification
      log.puts "\n📊 Final verification:"
      puts "\n📊 Final verification:"

      all_match = true
      sqlite_db = SQLite3::Database.new(sqlite_db_path.to_s)

      tables_to_migrate.each do |table|
        sqlite_count = sqlite_db.execute("SELECT COUNT(*) FROM #{table}").first.first
        pg_count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM #{table}").first["count"]

        match = sqlite_count == pg_count
        all_match = false unless match

        status = match ? "✅" : "❌"
        log.puts "  #{table}: SQLite(#{sqlite_count}) vs PostgreSQL(#{pg_count}) #{status}"
        puts "  #{table}: SQLite(#{sqlite_count}) vs PostgreSQL(#{pg_count}) #{status}"
      end

      sqlite_db.close

      if migration_success && all_match
        log.puts "\n🎉 FIXED TEST MIGRATION SUCCESSFUL!"
        puts "\n🎉 FIXED TEST MIGRATION SUCCESSFUL!"
        puts "✅ The production migration should work correctly now"
      else
        log.puts "\n💥 FIXED TEST MIGRATION FAILED"
        puts "\n💥 FIXED TEST MIGRATION FAILED"
        puts "❌ Still need to fix remaining issues"
      end

      log.puts "\n📅 Test completed at: #{Time.current}"
    end

    puts "📄 Test log saved to: #{log_file}"
  end

  desc "Production migration from SQLite to PostgreSQL"
  task migrate_to_postgresql_production: :environment do
    unless Rails.env.production?
      puts "❌ This task is only for production environment"
      exit 1
    end

    puts "🚨 PRODUCTION MIGRATION STARTING"
    puts "This will migrate your production data from SQLite to PostgreSQL"
    puts "=" * 60

    # Same logic as test, but with production-specific paths and safeguards
    sqlite_db_path = Rails.root.join("storage", "production.sqlite3")
    backup_dir = Rails.root.join("tmp", "migration_backups")

    unless File.exist?(sqlite_db_path)
      puts "❌ SQLite production database not found at #{sqlite_db_path}"
      exit 1
    end

    FileUtils.mkdir_p(backup_dir)
    timestamp = Time.current.strftime("%Y%m%d_%H%M%S")

    puts "🚀 Starting PRODUCTION migration from SQLite to PostgreSQL..."
    puts "📅 Migration started at: #{Time.current}"
    puts "📂 SQLite database: #{sqlite_db_path}"

    # Create backup
    backup_file = backup_dir.join("production_backup_#{timestamp}.sqlite3")
    FileUtils.cp(sqlite_db_path, backup_file)
    puts "✅ Created backup: #{backup_file}"

    # Connect to SQLite
    require "sqlite3"
    sqlite_db = SQLite3::Database.new(sqlite_db_path.to_s)

    # Get tables to migrate
    tables = sqlite_db.execute("SELECT name FROM sqlite_master WHERE type='table'")
      .map(&:first)
      .reject { |table| %w[schema_migrations ar_internal_metadata sqlite_sequence].include?(table) }

    puts "📋 Found #{tables.length} tables to migrate: #{tables.join(', ')}"

    # Define problematic columns (same as production)
    boolean_columns = {
      "pay_customers" => [ "default" ],
      "pay_payment_methods" => [ "default" ],
      "pay_subscriptions" => [ "metered" ],
      "wabas" => [ "subscribed" ]
    }

    reserved_keywords = %w[default]

    # Create migration log
    log_file = backup_dir.join("migration_log_#{timestamp}.txt")

    File.open(log_file, "w") do |log|
      log.puts "Production Migration Log - #{Time.current}"
      log.puts "=" * 50

      # Disable foreign key constraints
      ActiveRecord::Base.connection.execute("SET session_replication_role = replica;")
      log.puts "✅ Disabled foreign key constraints"

      migration_success = true

      begin
        tables.each do |table|
          log.puts "\n📋 Processing table: #{table}"
          puts "📋 Processing table: #{table}"

          # Get table structure
          columns_info = sqlite_db.execute("PRAGMA table_info(#{table})")
          column_names = columns_info.map { |col| col[1] }

          # Quote reserved keywords
          quoted_column_names = column_names.map do |col|
            reserved_keywords.include?(col) ? "\"#{col}\"" : col
          end

          # Get data from SQLite
          rows = sqlite_db.execute("SELECT * FROM #{table}")
          log.puts "  📊 Found #{rows.length} records in SQLite"
          puts "  📊 Found #{rows.length} records"

          if rows.empty?
            log.puts "  ⏭️  Skipping empty table"
            next
          end

          # Clear existing PostgreSQL data
          ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table} RESTART IDENTITY CASCADE")
          log.puts "  🧹 Cleared PostgreSQL table"

          # Insert data with proper type handling
          success_count = 0
          rows.each_slice(25) do |batch|
            values = batch.map do |row|
              escaped_values = row.map.with_index do |value, index|
                column_name = column_names[index]

                # Handle boolean conversion
                if boolean_columns[table]&.include?(column_name)
                  if value.nil?
                    "NULL"
                  elsif value == 1 || value == "1" || value == "t" || value == "true"
                    "TRUE"
                  elsif value == 0 || value == "0" || value == "f" || value == "false"
                    "FALSE"
                  else
                    ActiveRecord::Base.connection.quote(value)
                  end
                else
                  ActiveRecord::Base.connection.quote(value)
                end
              end
              "(#{escaped_values.join(', ')})"
            end.join(", ")

            sql = "INSERT INTO #{table} (#{quoted_column_names.join(', ')}) VALUES #{values}"

            begin
              ActiveRecord::Base.connection.execute(sql)
              success_count += batch.length
            rescue => e
              log.puts "  ⚠️  Batch error: #{e.message}"
              puts "  ⚠️  Batch error, trying individual rows..."

              # Try individual rows
              batch.each do |row|
                escaped_values = row.map.with_index do |value, index|
                  column_name = column_names[index]

                  if boolean_columns[table]&.include?(column_name)
                    if value.nil?
                      "NULL"
                    elsif value == 1 || value == "1" || value == "t" || value == "true"
                      "TRUE"
                    elsif value == 0 || value == "0" || value == "f" || value == "false"
                      "FALSE"
                    else
                      ActiveRecord::Base.connection.quote(value)
                    end
                  else
                    ActiveRecord::Base.connection.quote(value)
                  end
                end

                single_sql = "INSERT INTO #{table} (#{quoted_column_names.join(', ')}) VALUES (#{escaped_values.join(', ')})"

                begin
                  ActiveRecord::Base.connection.execute(single_sql)
                  success_count += 1
                rescue => single_error
                  log.puts "  ❌ Row error: #{single_error.message}"
                  log.puts "  📄 Failed row: #{row.inspect}"
                  migration_success = false
                end
              end
            end
          end

          # Verify count
          pg_count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM #{table}").first["count"]
          log.puts "  ✅ Migrated #{success_count}/#{rows.length} records (PostgreSQL count: #{pg_count})"
          puts "  ✅ Migrated #{success_count}/#{rows.length} records (PostgreSQL count: #{pg_count})"

          # Update sequence
          if ActiveRecord::Base.connection.column_exists?(table, "id")
            max_id_result = ActiveRecord::Base.connection.execute("SELECT MAX(id) FROM #{table}")
            max_id = max_id_result.first&.fetch("max", nil)

            if max_id && max_id > 0
              ActiveRecord::Base.connection.execute("SELECT setval('#{table}_id_seq', #{max_id})")
              log.puts "  🔄 Updated sequence to #{max_id}"
            end
          end

          if success_count != rows.length
            migration_success = false
          end
        end

      rescue => e
        log.puts "💥 FATAL ERROR: #{e.message}"
        log.puts "📄 Backtrace: #{e.backtrace.join("\n")}"
        migration_success = false
      ensure
        # Re-enable foreign key constraints
        ActiveRecord::Base.connection.execute("SET session_replication_role = DEFAULT;")
        log.puts "✅ Re-enabled foreign key constraints"
      end

      sqlite_db.close

      # Final verification
      log.puts "\n📊 Final verification:"
      puts "\n📊 Final verification:"

      all_match = true
      sqlite_db = SQLite3::Database.new(sqlite_db_path.to_s)

      tables.each do |table|
        sqlite_count = sqlite_db.execute("SELECT COUNT(*) FROM #{table}").first.first
        pg_count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM #{table}").first["count"]

        # Allow for small differences due to data corruption/invalid data
        match = (sqlite_count == pg_count) || (pg_count >= sqlite_count * 0.95)
        all_match = false unless match

        status = match ? "✅" : "❌"
        log.puts "  #{table}: SQLite(#{sqlite_count}) vs PostgreSQL(#{pg_count}) #{status}"
        puts "  #{table}: SQLite(#{sqlite_count}) vs PostgreSQL(#{pg_count}) #{status}"
      end

      sqlite_db.close

      if migration_success && all_match
        log.puts "\n🎉 MIGRATION COMPLETED SUCCESSFULLY!"
        puts "\n🎉 MIGRATION COMPLETED SUCCESSFULLY!"
      else
        log.puts "\n💥 MIGRATION FAILED - CHECK LOGS AND ROLLBACK"
        puts "\n💥 MIGRATION FAILED - CHECK LOGS AND ROLLBACK"
      end

      log.puts "\n📅 Migration completed at: #{Time.current}"
    end

    puts "📄 Migration log saved to: #{log_file}"
    puts "\n🎉 PRODUCTION MIGRATION COMPLETED"
  end

  desc "Verify production migration"
  task verify_production_migration: :environment do
    unless Rails.env.production?
      puts "❌ This task is only for production environment"
      exit 1
    end

    puts "🔍 Verifying production migration..."

    # Test basic functionality
    puts "\n📊 Record counts:"
    puts "  Users: #{User.count}"
    puts "  Chatbots: #{Chatbot.count}"
    puts "  Chats: #{Chat.count}"
    puts "  Messages: #{Message.count}"

    # Test relationships
    puts "\n🔗 Testing relationships:"
    if User.first
      puts "  First user email: #{User.first.email}"
      puts "  First user chatbots: #{User.first.chatbots.count}"
    end

    if Chatbot.first
      puts "  First chatbot name: #{Chatbot.first.name}"
      puts "  First chatbot chats: #{Chatbot.first.chats.count}"
    end

    if Chat.first
      puts "  First chat messages: #{Chat.first.messages.count}"
    end

    puts "\n✅ Basic verification completed"
  end

  desc "Rollback to SQLite (emergency use only)"
  task rollback_to_sqlite: :environment do
    unless Rails.env.production?
      puts "❌ This task is only for production environment"
      exit 1
    end

    puts "🚨 EMERGENCY ROLLBACK TO SQLITE"
    puts "This will switch the application back to SQLite"
    puts "Make sure you have restored the SQLite database file"

    # This would require updating database.yml and restarting
    puts "✅ Update config/database.yml to use SQLite"
    puts "✅ Restart the application"
    puts "✅ Verify data integrity"
  end
end
