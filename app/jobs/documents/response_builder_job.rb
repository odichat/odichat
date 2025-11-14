require "pagy"

class Documents::ResponseBuilderJob < ApplicationJob
  include Pagy::Backend
  queue_as :default

  def perform(document_id, options = {})
    document = Document.find(document_id)
    return if document.blank?

    faqs = generate_faqs(document, options)
    create_responses_from_faqs(faqs, document)
    broadcast_responses_list(document)
  end

  private

  def generate_faqs(document, options)
    generate_paginated_faqs(document, options)
  end

  def generate_paginated_faqs(document, options)
    service = build_paginated_service(document, options)
    faqs = service.generate
    # store_paginated_metadata(document, service)
    faqs
  end

  def build_paginated_service(document, options)
    Llm::PaginatedFaqGeneratorService.new(
      document,
      pages_per_chunk: options[:pages_per_chunk],
      max_pages: options[:max_pages]
    )
  end

  def create_responses_from_faqs(faqs, document)
    chatbot = document.chatbot
    faqs.each { |faq| create_response(faq, chatbot, document.id) }
  end

  def create_response(faq, chatbot, document_id)
    chatbot.responses.create!(
      question: faq["question"],
      answer: faq["answer"],
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Could not create response", error: e.message, document_id: document_id)
  end

  def broadcast_responses_list(document)
    return if document.nil?
    chatbot = document.chatbot
    responses_scope = chatbot.responses.order(created_at: :desc)
    stream = [ chatbot, :responses ]
    per_page = 10
    pagy = Pagy::Countless.new(page: 1, limit: per_page)
    fetched_responses = responses_scope.limit(pagy.limit + 1).to_a
    pagy.finalize(fetched_responses.size)
    paginated_responses = fetched_responses.first(pagy.limit)

    Turbo::StreamsChannel.broadcast_replace_to(
      stream,
      target: ActionView::RecordIdentifier.dom_id(chatbot, :responses_list),
      partial: "chatbots/responses/responses_list",
      locals: {
        chatbot: chatbot,
        responses: paginated_responses,
        pagy: pagy,
        is_processing_documents: chatbot.documents.pending.any?
      }
    )

    Turbo::StreamsChannel.broadcast_replace_to(
      stream,
      target: "flash",
      partial: "shared/flash_messages",
      locals: { flash: { notice: "Document #{document.file.blob.filename} has been processed." } }
    )
  end
end
