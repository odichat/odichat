class Response < ApplicationRecord
  belongs_to :faq,
            class_name: "Roleable::Faq",
            foreign_key: :roleable_faq_id,
            inverse_of: :responses

  validates :question, presence: true
  validates :answer, presence: true
  validates :roleable_faq_id, presence: true

  has_neighbors :embedding, normalize: true

  # after_create_commit :execute_after_create_commit_callbacks
  after_commit :generate_embedding, on: [ :create, :update ]

  def self.search(query)
    embedding = Llm::EmbeddingService.new.generate_embedding(query)
    nearest_neighbors(:embedding, embedding, distance: :cosine).limit(3)
  end

  def broadcast_append_to_responses_list(partial: "chatbots/responses/response")
      chatbot = faq&.chatbot
      return unless chatbot

      stream = [ chatbot, :responses ]
      target = ActionView::RecordIdentifier.dom_id(chatbot, :responses_list)
      loader_target = ActionView::RecordIdentifier.dom_id(chatbot, :processing_loader)
      empty_state_target = ActionView::RecordIdentifier.dom_id(chatbot, :no_responses_uploaded)

      broadcast_remove_to(stream, target: loader_target)
      broadcast_remove_to(stream, target: empty_state_target)

      broadcast_prepend_later_to(
        stream,
        target: target,
        partial: partial,
        locals: {
          response: self,
          chatbot: chatbot
        }
      )
    end

  private

    def execute_after_create_commit_callbacks
      broadcast_append_to_responses_list
    end

    def generate_embedding
      return unless saved_change_to_question? || saved_change_to_answer? || embedding.nil?

      Llm::EmbeddingJob.perform_later(self, "#{question}: #{answer}")
    end
end
