class MissingVectorStoreIdError < StandardError
  def initialize(msg = "Vector Store ID is required to remove document from OpenAI")
    super
  end
end
