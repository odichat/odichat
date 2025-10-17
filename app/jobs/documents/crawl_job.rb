class Documents::CrawlJob < ApplicationJob
  queue_as :default

  def perform(document_id)
    document = Document.find(document_id)
    return if document.blank?

    if document.pdf_document?
      perform_pdf_processing(document)
    end
  end

  private

  def perform_pdf_processing(document)
    Llm::PdfProcessingService.new(document).process
    document.update!(status: :uploaded)
  end
end
