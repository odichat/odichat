namespace :after_party do
  desc "Deployment task: Ensure all existing chatbots have a shareable link"
  task backfill_shareable_links_for_chatbots: :environment do
    puts "Running deploy task 'backfill_shareable_links_for_chatbots'"

    # Put your task implementation HERE.
    Chatbot.find_each do |chatbot|
      if chatbot.shareable_link.nil?
        ShareableLink.create!(chatbot: chatbot, token: SecureRandom.uuid)
        puts "Created shareable link for Chatbot ##{chatbot.id}"
      else
        puts "Chatbot ##{chatbot.id} already has a shareable link. Skipping."
      end
    end

    puts "Finished deploy task 'backfill_shareable_links_for_chatbots'"

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end
