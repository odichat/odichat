class Model < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :provider, presence: true
end
