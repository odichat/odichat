namespace :db do
  desc "Migrate development data from SQLite to PostgreSQL"
  task migrate_development_data: :environment do
    unless Rails.env.development?
      puts "❌ This task is only for development environment"
      exit 1
    end

    # Path to your old SQLite development database
    sqlite_db_path = Rails.root.join("storage", "development.sqlite3")

    unless File.exist?(sqlite_db_path)
      puts "❌ SQLite development database not found at #{sqlite_db_path}"
      puts "Make sure you have the old SQLite development database file"
      exit 1
    end

    puts "🚀 Starting migration from SQLite to PostgreSQL..."
    puts "📂 Reading from: #{sqlite_db_path}"

    # Connect to SQLite database
    require "sqlite3"
    sqlite_db = SQLite3::Database.new(sqlite_db_path.to_s)

    # Get all table names except Rails internal tables
    tables = sqlite_db.execute("SELECT name FROM sqlite_master WHERE type='table'")
      .map(&:first)
      .reject { |table| %w[schema_migrations ar_internal_metadata sqlite_sequence].include?(table) }

    puts "📋 Found tables: #{tables.join(', ')}"

    # Define boolean columns that need conversion
    boolean_columns = {
      "pay_customers" => [ "default" ],
      "pay_payment_methods" => [ "default" ],
      "pay_subscriptions" => [ "metered" ],
      "wabas" => [ "subscribed" ]
    }

    # Define reserved keywords that need quoting
    reserved_keywords = %w[default]

    # Disable foreign key constraints temporarily
    ActiveRecord::Base.connection.execute("SET session_replication_role = replica;")

    begin
      tables.each do |table|
        puts "\n📋 Migrating table: #{table}"

        # Get table structure from SQLite
        columns_info = sqlite_db.execute("PRAGMA table_info(#{table})")
        column_names = columns_info.map { |col| col[1] }

        # Quote reserved keywords
        quoted_column_names = column_names.map do |col|
          reserved_keywords.include?(col) ? "\"#{col}\"" : col
        end

        # Get all data from SQLite
        rows = sqlite_db.execute("SELECT * FROM #{table}")

        puts "  📊 Found #{rows.length} records"

        if rows.empty?
          puts "  ⏭️  Skipping empty table"
          next
        end

        # Clear existing data in PostgreSQL
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table} RESTART IDENTITY CASCADE")

        # Insert data into PostgreSQL in batches
        rows.each_slice(50) do |batch|
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
          rescue => e
            puts "  ⚠️  Error inserting batch: #{e.message}"
            puts "  🔄 Trying individual row insertion..."

            # Try inserting row by row for this batch
            batch.each do |row|
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

              single_sql = "INSERT INTO #{table} (#{quoted_column_names.join(', ')}) VALUES (#{escaped_values.join(', ')})"

              begin
                ActiveRecord::Base.connection.execute(single_sql)
              rescue => single_error
                puts "  ❌ Failed to insert row: #{single_error.message}"
                puts "  📄 Row data: #{row.inspect}"
                puts "  🔍 SQL: #{single_sql}"
              end
            end
          end
        end

        # Get actual count from PostgreSQL
        actual_count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM #{table}").first["count"]
        puts "  ✅ Successfully migrated #{actual_count} records"
      end

      # Update sequences for PostgreSQL
      puts "\n🔄 Updating ID sequences..."
      tables.each do |table|
        if ActiveRecord::Base.connection.column_exists?(table, "id")
          begin
            max_id_result = ActiveRecord::Base.connection.execute("SELECT MAX(id) FROM #{table}")
            max_id = max_id_result.first&.fetch("max", nil)

            if max_id && max_id > 0
              ActiveRecord::Base.connection.execute("SELECT setval('#{table}_id_seq', #{max_id})")
              puts "  🔄 Updated sequence for #{table} to #{max_id}"
            else
              puts "  ⏭️  No ID sequence needed for #{table}"
            end
          rescue => e
            puts "  ⚠️  Could not update sequence for #{table}: #{e.message}"
          end
        end
      end

    ensure
      # Re-enable foreign key constraints
      ActiveRecord::Base.connection.execute("SET session_replication_role = DEFAULT;")
    end

    sqlite_db.close
    puts "\n🎉 Migration completed successfully!"
    puts "\n📊 Final counts:"

    # Show final record counts
    tables.each do |table|
      begin
        count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM #{table}").first["count"]
        puts "  #{table}: #{count} records"
      rescue => e
        puts "  #{table}: Error getting count - #{e.message}"
      end
    end
  end

  desc "Clear all PostgreSQL data (for retrying migration)"
  task clear_postgres_data: :environment do
    unless Rails.env.development?
      puts "❌ This task is only for development environment"
      exit 1
    end

    puts "🧹 Clearing all PostgreSQL data..."

    # Get all table names
    tables = ActiveRecord::Base.connection.tables.reject do |table|
      %w[schema_migrations ar_internal_metadata].include?(table)
    end

    # Disable foreign key constraints
    ActiveRecord::Base.connection.execute("SET session_replication_role = replica;")

    begin
      tables.each do |table|
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table} RESTART IDENTITY CASCADE")
        puts "  🧹 Cleared #{table}"
      end
    ensure
      ActiveRecord::Base.connection.execute("SET session_replication_role = DEFAULT;")
    end

    puts "✅ All tables cleared!"
  end

  desc "Migrate specific missing tables"
  task migrate_missing_tables: :environment do
    unless Rails.env.development?
      puts "❌ This task is only for development environment"
      exit 1
    end

    # Tables that are missing data
    missing_tables = %w[messages chats documents shareable_links contacts vector_stores]

    sqlite_db_path = Rails.root.join("storage", "development.sqlite3")
    require "sqlite3"
    sqlite_db = SQLite3::Database.new(sqlite_db_path.to_s)

    puts "🚀 Migrating missing tables from SQLite to PostgreSQL..."

    # Disable foreign key constraints temporarily
    ActiveRecord::Base.connection.execute("SET session_replication_role = replica;")

    begin
      missing_tables.each do |table|
        puts "\n📋 Migrating #{table}..."

        # Check if table exists in SQLite
        table_exists = sqlite_db.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='#{table}'").any?
        unless table_exists
          puts "  ⏭️  Table #{table} doesn't exist in SQLite, skipping"
          next
        end

        # Get table structure
        columns_info = sqlite_db.execute("PRAGMA table_info(#{table})")
        column_names = columns_info.map { |col| col[1] }

        # Get data from SQLite
        rows = sqlite_db.execute("SELECT * FROM #{table}")
        puts "  📊 Found #{rows.length} records in SQLite"

        if rows.empty?
          puts "  ⏭️  No data to migrate"
          next
        end

        # Check current count in PostgreSQL
        pg_count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM #{table}").first["count"]
        puts "  📊 Current PostgreSQL count: #{pg_count}"

        # Clear existing data in PostgreSQL
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table} RESTART IDENTITY CASCADE")
        puts "  🧹 Cleared existing PostgreSQL data"

        # Insert data in batches
        rows.each_slice(25) do |batch|
          values = batch.map do |row|
            escaped_values = row.map { |value| ActiveRecord::Base.connection.quote(value) }
            "(#{escaped_values.join(', ')})"
          end.join(", ")

          sql = "INSERT INTO #{table} (#{column_names.join(', ')}) VALUES #{values}"

          begin
            ActiveRecord::Base.connection.execute(sql)
          rescue => e
            puts "  ⚠️  Batch error: #{e.message}"
            puts "  🔄 Trying individual rows..."

            # Try row by row
            batch.each do |row|
              escaped_values = row.map { |value| ActiveRecord::Base.connection.quote(value) }
              single_sql = "INSERT INTO #{table} (#{column_names.join(', ')}) VALUES (#{escaped_values.join(', ')})"

              begin
                ActiveRecord::Base.connection.execute(single_sql)
              rescue => single_error
                puts "  ❌ Row error: #{single_error.message}"
                puts "  📄 Row data: #{row.inspect}"
              end
            end
          end
        end

        # Verify final count
        final_count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM #{table}").first["count"]
        puts "  ✅ Final PostgreSQL count: #{final_count}"

        # Update sequence if table has ID column
        if ActiveRecord::Base.connection.column_exists?(table, "id")
          max_id_result = ActiveRecord::Base.connection.execute("SELECT MAX(id) FROM #{table}")
          max_id = max_id_result.first&.fetch("max", nil)

          if max_id && max_id > 0
            ActiveRecord::Base.connection.execute("SELECT setval('#{table}_id_seq', #{max_id})")
            puts "  🔄 Updated sequence to #{max_id}"
          end
        end
      end

    ensure
      # Re-enable foreign key constraints
      ActiveRecord::Base.connection.execute("SET session_replication_role = DEFAULT;")
    end

    sqlite_db.close
    puts "\n🎉 Missing tables migration completed!"
  end

  desc "Check data counts between SQLite and PostgreSQL"
  task compare_data_counts: :environment do
    unless Rails.env.development?
      puts "❌ This task is only for development environment"
      exit 1
    end

    sqlite_db_path = Rails.root.join("storage", "development.sqlite3")
    require "sqlite3"
    sqlite_db = SQLite3::Database.new(sqlite_db_path.to_s)

    # Get all table names
    tables = sqlite_db.execute("SELECT name FROM sqlite_master WHERE type='table'")
      .map(&:first)
      .reject { |table| %w[schema_migrations ar_internal_metadata sqlite_sequence].include?(table) }

    puts "📊 Data count comparison:"
    puts "%-25s %-10s %-10s %-10s" % [ "Table", "SQLite", "PostgreSQL", "Match" ]
    puts "-" * 60

    tables.each do |table|
      sqlite_count = sqlite_db.execute("SELECT COUNT(*) FROM #{table}").first.first

      begin
        pg_count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM #{table}").first["count"]
        match = sqlite_count == pg_count ? "✅" : "❌"
        puts "%-25s %-10d %-10d %-10s" % [ table, sqlite_count, pg_count, match ]
      rescue => e
        puts "%-25s %-10d %-10s %-10s" % [ table, sqlite_count, "ERROR", "❌" ]
      end
    end

    sqlite_db.close
  end

  desc "Fix specific problematic tables (messages, chats, wabas)"
  task fix_problematic_tables: :environment do
    unless Rails.env.development?
      puts "❌ This task is only for development environment"
      exit 1
    end

    sqlite_db_path = Rails.root.join("storage", "development.sqlite3")
    require "sqlite3"
    sqlite_db = SQLite3::Database.new(sqlite_db_path.to_s)

    puts "🚀 Fixing problematic tables..."

    # Disable foreign key constraints temporarily
    ActiveRecord::Base.connection.execute("SET session_replication_role = replica;")

    begin
      # Fix messages table
      puts "\n📋 Fixing messages table..."
      columns_info = sqlite_db.execute("PRAGMA table_info(messages)")
      column_names = columns_info.map { |col| col[1] }
      rows = sqlite_db.execute("SELECT * FROM messages")

      if rows.any?
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE messages RESTART IDENTITY CASCADE")

        rows.each do |row|
          escaped_values = row.map { |value| ActiveRecord::Base.connection.quote(value) }
          sql = "INSERT INTO messages (#{column_names.join(', ')}) VALUES (#{escaped_values.join(', ')})"
          ActiveRecord::Base.connection.execute(sql)
        end

        # Update sequence
        max_id = ActiveRecord::Base.connection.execute("SELECT MAX(id) FROM messages").first&.fetch("max", nil)
        if max_id && max_id > 0
          ActiveRecord::Base.connection.execute("SELECT setval('messages_id_seq', #{max_id})")
        end

        puts "  ✅ Migrated #{rows.length} messages"
      end

      # Fix chats table
      puts "\n📋 Fixing chats table..."
      columns_info = sqlite_db.execute("PRAGMA table_info(chats)")
      column_names = columns_info.map { |col| col[1] }
      rows = sqlite_db.execute("SELECT * FROM chats")

      if rows.any?
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE chats RESTART IDENTITY CASCADE")

        rows.each do |row|
          escaped_values = row.map { |value| ActiveRecord::Base.connection.quote(value) }
          sql = "INSERT INTO chats (#{column_names.join(', ')}) VALUES (#{escaped_values.join(', ')})"
          ActiveRecord::Base.connection.execute(sql)
        end

        # Update sequence
        max_id = ActiveRecord::Base.connection.execute("SELECT MAX(id) FROM chats").first&.fetch("max", nil)
        if max_id && max_id > 0
          ActiveRecord::Base.connection.execute("SELECT setval('chats_id_seq', #{max_id})")
        end

        puts "  ✅ Migrated #{rows.length} chats"
      end

      # Fix wabas table (with boolean handling)
      puts "\n📋 Fixing wabas table..."
      columns_info = sqlite_db.execute("PRAGMA table_info(wabas)")
      column_names = columns_info.map { |col| col[1] }
      rows = sqlite_db.execute("SELECT * FROM wabas")

      if rows.any?
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE wabas RESTART IDENTITY CASCADE")

        rows.each do |row|
          escaped_values = row.map.with_index do |value, index|
            column_name = column_names[index]

            # Handle boolean conversion for 'subscribed' column
            if column_name == "subscribed"
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

          sql = "INSERT INTO wabas (#{column_names.join(', ')}) VALUES (#{escaped_values.join(', ')})"
          ActiveRecord::Base.connection.execute(sql)
        end

        # Update sequence
        max_id = ActiveRecord::Base.connection.execute("SELECT MAX(id) FROM wabas").first&.fetch("max", nil)
        if max_id && max_id > 0
          ActiveRecord::Base.connection.execute("SELECT setval('wabas_id_seq', #{max_id})")
        end

        puts "  ✅ Migrated #{rows.length} wabas"
      end

    ensure
      # Re-enable foreign key constraints
      ActiveRecord::Base.connection.execute("SET session_replication_role = DEFAULT;")
    end

    sqlite_db.close
    puts "\n🎉 Problematic tables fixed!"
  end

  desc "Debug and fix messages table specifically"
  task fix_messages_table: :environment do
    unless Rails.env.development?
      puts "❌ This task is only for development environment"
      exit 1
    end

    sqlite_db_path = Rails.root.join("storage", "development.sqlite3")
    require "sqlite3"
    sqlite_db = SQLite3::Database.new(sqlite_db_path.to_s)

    puts "🔍 Debugging messages table..."

    # Check table structure
    puts "\n📋 Messages table structure in SQLite:"
    columns_info = sqlite_db.execute("PRAGMA table_info(messages)")
    columns_info.each do |col|
      puts "  #{col[1]} (#{col[2]})"
    end

    # Check PostgreSQL structure
    puts "\n📋 Messages table structure in PostgreSQL:"
    pg_columns = ActiveRecord::Base.connection.execute("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'messages' ORDER BY ordinal_position")
    pg_columns.each do |col|
      puts "  #{col['column_name']} (#{col['data_type']})"
    end

    # Get sample data
    puts "\n📊 Sample data from SQLite:"
    sample_rows = sqlite_db.execute("SELECT * FROM messages LIMIT 3")
    column_names = columns_info.map { |col| col[1] }

    sample_rows.each_with_index do |row, i|
      puts "  Row #{i + 1}:"
      column_names.each_with_index do |col_name, j|
        puts "    #{col_name}: #{row[j].inspect}"
      end
    end

    puts "\n🚀 Attempting to migrate messages..."

    # Get all messages
    rows = sqlite_db.execute("SELECT * FROM messages")
    puts "📊 Found #{rows.length} messages in SQLite"

    # Clear existing data
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE messages RESTART IDENTITY CASCADE")

    # Try to insert one by one with detailed error reporting
    success_count = 0
    rows.each_with_index do |row, index|
      escaped_values = row.map { |value| ActiveRecord::Base.connection.quote(value) }
      sql = "INSERT INTO messages (#{column_names.join(', ')}) VALUES (#{escaped_values.join(', ')})"

      begin
        ActiveRecord::Base.connection.execute(sql)
        success_count += 1

        # Show progress every 25 records
        if (index + 1) % 25 == 0
          puts "  📈 Processed #{index + 1}/#{rows.length} messages"
        end
      rescue => e
        puts "  ❌ Error on message #{index + 1}: #{e.message}"
        puts "  📄 SQL: #{sql}"
        puts "  📄 Row data: #{row.inspect}"

        # Stop after too many errors
        if (index + 1 - success_count) > 5
          puts "  ⚠️  Too many errors, stopping..."
          break
        end
      end
    end

    # Update sequence
    if success_count > 0
      max_id = ActiveRecord::Base.connection.execute("SELECT MAX(id) FROM messages").first&.fetch("max", nil)
      if max_id && max_id > 0
        ActiveRecord::Base.connection.execute("SELECT setval('messages_id_seq', #{max_id})")
        puts "  🔄 Updated sequence to #{max_id}"
      end
    end

    final_count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM messages").first["count"]
    puts "\n✅ Successfully migrated #{success_count} out of #{rows.length} messages"
    puts "📊 Final PostgreSQL count: #{final_count}"

    sqlite_db.close
  end
end
