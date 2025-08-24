class MigrateExistingPlaygroundCHats < ActiveRecord::Migration[8.0]
  def up
    puts "🔄 Migrating existing playground chats to channel structure..."

    # Find all existing playground chats that don't have inbox_id (old structure)
    old_playground_chats = Chat.where(source: 'playground', inbox_id: nil)
    old_public_playground_chats = Chat.where(source: 'public_playground', inbox_id: nil)

    puts "📊 Found #{old_playground_chats.count} playground chats and #{old_public_playground_chats.count} public playground chats to migrate"

    # Group chats by chatbot to avoid creating duplicate channels
    playground_chatbots = old_playground_chats.includes(:chatbot).group_by(&:chatbot)
    public_playground_chatbots = old_public_playground_chats.includes(:chatbot).group_by(&:chatbot)

    # Migrate regular playground chats
    playground_chatbots.each do |chatbot, chats|
      puts "🔧 Migrating playground chat for chatbot #{chatbot.id}"

      # Create playground channel if it doesn't exist
      playground_channel = chatbot.playground_channels.first_or_create!

      # Create inbox for this channel
      inbox = Inbox.find_or_create_by(chatbot: chatbot, channel: playground_channel)

      # Update all playground chats for this chatbot
      chats.each do |chat|
        chat.update!(inbox: inbox)
        puts "  ✅ Updated playground chat #{chat.id}"
      end
    end

    # Migrate public playground chats
    public_playground_chatbots.each do |chatbot, chats|
      puts "🔧 Migrating public playground chat for chatbot #{chatbot.id}"

      # Create public playground channel if it doesn't exist
      public_playground_channel = chatbot.public_playground_channels.first_or_create!

      # Create inbox for this channel
      inbox = Inbox.find_or_create_by(chatbot: chatbot, channel: public_playground_channel)

      # Update all public playground chats for this chatbot
      chats.each do |chat|
        chat.update!(inbox: inbox)
        puts "  ✅ Updated public playground chat #{chat.id}"
      end
    end

    puts "🎉 Migration completed successfully!"
    puts "📊 Final counts:"
    puts "  - Playground channels: #{Channel::Playground.count}"
    puts "  - Public playground channels: #{Channel::PublicPlayground.count}"
    puts "  - Playground chats with inbox: #{Chat.joins(:inbox).joins('JOIN channel_playground ON inboxes.channel_id = channel_playground.id AND inboxes.channel_type = \'Channel::Playground\'').count}"
    puts "  - Public playground chats with inbox: #{Chat.joins(:inbox).joins('JOIN channel_public_playground ON inboxes.channel_id = channel_public_playground.id AND inboxes.channel_type = \'Channel::PublicPlayground\'').count}"
  end

  def down
    puts "🔄 Reverting playground chat migration..."

    # Find all playground and public playground chats
    playground_chats = Chat.joins(:inbox).where(inboxes: { channel_type: 'Channel::Playground' })
    public_playground_chats = Chat.joins(:inbox).where(inboxes: { channel_type: 'Channel::PublicPlayground' })

    puts "📊 Reverting #{playground_chats.count} playground chats and #{public_playground_chats.count} public playground chats"

    # Remove inbox association from chats
    playground_chats.update_all(inbox_id: nil)
    public_playground_chats.update_all(inbox_id: nil)

    # Delete playground channels and their inboxes
    Channel::Playground.destroy_all
    Channel::PublicPlayground.destroy_all

    puts "🎉 Reversion completed!"
  end
end
