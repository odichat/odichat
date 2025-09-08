class Llm::BaseOpenAiService
  DEFAULT_MODEL = "gpt-5-mini-2025-08-07".freeze

  attr_reader :client, :model

  def initialize(model_id: nil)
    @client = OpenAI::Client.new
    # Code to log requests and responses, use only for debugging
    # @client = OpenAI::Client.new do |f|
    #   f.response :logger, Logger.new($stdout), bodies: true
    # end
    setup_model(model_id)
  rescue => e
    raise "Failed to initialize OpenAI client: #{e.message}"
  end

  private

  def setup_model(model_id)
    @model = Model.find_by(id: model_id) || Model.find_by(name: DEFAULT_MODEL)
  end
end
