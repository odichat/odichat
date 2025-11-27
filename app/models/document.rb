class Document < ApplicationRecord
  include OpenaiClient

  attr_accessor :vector_store_id_for_cleanup, :file_id_for_cleanup

  belongs_to :chatbot
  has_one_attached :file

  after_create_commit :enqueue_crawl_job
  after_commit :enqueue_response_builder_job, on: :update, if: :should_enqueue_response_builder?
  before_destroy :cache_cleanup_identifiers
  after_destroy_commit :enqueue_cleanup_job

  enum :status, { pending: 0, uploaded: 1, failed: 2, deleting: 3 }

  validates :file, content_type: [ "application/pdf", "text/plain", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "text/html" ]

  def upload_file(file_path, purpose = "user_data")
    response = openai_client.files.upload(parameters: { file: file_path, purpose: purpose })
    response["id"]
  end

  class << self
    def enqueue_remove_from_storage_job(vector_store_id, file_id)
      return if vector_store_id.blank? || file_id.blank?

      RemoveDocumentFromOpenaiJob.perform_later(vector_store_id, file_id)
    end

    def remove_from_storage(vector_store_id, file_id)
      openai_client.vector_store_files.delete(
        vector_store_id: vector_store_id,
        id: file_id
      )
      openai_client.files.delete(id: file_id)
    rescue OpenAI::Error => e
      Rails.logger.error("Error removing document from OpenAI: #{e.message}")
      raise OpenAI::Error, "Error removing document from OpenAI: #{e.message}"
    end
  end

  def store_openai_file_id(file_id)
    update!(file_id:)
  end

  def pdf_document?
    file.attached? && file.content_type == "application/pdf"
  end

  private

  def should_enqueue_response_builder?
    saved_change_to_status? && uploaded?
  end

  def enqueue_crawl_job
    return if !pending?

    Documents::CrawlJob.perform_later(self.id)
  end

  def enqueue_response_builder_job
    return if !uploaded?

    Documents::ResponseBuilderJob.perform_later(self.id)
  end

  def cache_cleanup_identifiers
    return if file_id.blank?

    self.vector_store_id_for_cleanup = chatbot&.vector_store&.vector_store_id
    self.file_id_for_cleanup = file_id
  end

  def enqueue_cleanup_job
    Document.enqueue_remove_from_storage_job(vector_store_id_for_cleanup, file_id_for_cleanup)
  end
end
