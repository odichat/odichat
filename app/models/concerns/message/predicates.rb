module Message::Predicates
  extend ActiveSupport::Concern

  def assistant?
    sender == "assistant"
  end

  def user?
    sender == "user"
  end
end
