class Chat < ApplicationRecord
  include OpenaiClient

  belongs_to :chatbot

  has_many :messages, dependent: :destroy

  validates :source, presence: true
end
