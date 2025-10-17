class Documents::ResponseBuilderJob < ApplicationJob
  queue_as :default

  def perform(document_id, options = {})
    document = Document.find(document_id)
    return if document.blank?

    faqs = generate_faqs(document, options)
    create_responses_from_faqs(faqs, document)
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
    faqs.each { |faq| create_response(faq, document) }
  end

  def create_response(faq, document)
    Response.create!(
      question: faq["question"],
      answer: faq["answer"],
      roleable_faq_id: document.chatbot.scenarios.find_by(roleable_type: "Roleable::Faq")&.roleable_id
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Could not create response", error: e.message)
  end
end
