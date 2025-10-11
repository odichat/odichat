class Chatbot::ResponseSchema < RubyLLM::Schema
  string :response, description: "The message to send the user"
  string :reasoning, description: "The assistant thought process"
end
