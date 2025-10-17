class Llm::PdfProcessingService
  include OpenaiClient

  def initialize(document)
    @document = document
  end

  def process
    return if @document.file_id.present?

    file_id = upload_pdf_to_openai

    raise StandardError, "Document upload to OpenAI service failed" if file_id.blank?

    @document.store_openai_file_id(file_id)
  end

  private

    def upload_pdf_to_openai
      with_tempfile do |temp_file|
        response = openai_client.files.upload(
          parameters: {
            file: temp_file,
            purpose: "assistants"
          }
        )
        response["id"]
      end
    end

    def with_tempfile(&)
      Tempfile.create([ "pdf_upload", ".pdf" ], binmode: true) do |temp_file|
        temp_file.write(@document.file.download)
        temp_file.close

        File.open(temp_file.path, "rb", &)
      end
    end
end
