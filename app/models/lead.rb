class Lead < ApplicationRecord
  belongs_to :chatbot
  belongs_to :contact

  delegate :name, :phone_number, to: :contact

  after_create_commit :generate_intent_summary

  private

    def generate_intent_summary
      puts "*******************"
      puts "GENERATING INTENT SUMMARY"
      puts "*******************"
    end
end
