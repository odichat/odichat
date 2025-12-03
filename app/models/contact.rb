class Contact < ApplicationRecord
  attr_accessor :skip_phone_number_validation

  belongs_to :chatbot
  has_one :conversation, dependent: :destroy
  has_many :contact_inboxes, dependent: :destroy
  has_many :inboxes, through: :contact_inboxes
  has_many :chats, through: :contact_inboxes

  has_many :leads, dependent: :destroy

  validates :phone_number,
            presence: true,
            uniqueness: {
              scope: :chatbot_id,
              case_sensitive: false
            },
            unless: :skip_phone_number_validation?

  def get_source_id(inbox_id)
    contact_inboxes.find_by!(inbox_id: inbox_id).source_id
  end

  def skip_phone_number_validation?
    @skip_phone_number_validation
  end
end
