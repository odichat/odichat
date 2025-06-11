class Llm::BaseOpenAiService
  DEFAULT_MODEL = "gpt-4o-mini".freeze

  attr_reader :client, :model

  def initialize(model_id: nil)
    @client = OpenAI::Client.new
    setup_model(model_id)
  rescue => e
    raise "Failed to initialize OpenAI client: #{e.message}"
  end

  private

  def setup_model(model_id)
    @model = Model.find(model_id) || Model.find_by(name: DEFAULT_MODEL)
  end
end
