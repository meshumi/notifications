class Domain < ApplicationRecord
  has_many :notification_receivers
  has_many :posts
  has_one :frequency

  validates :name, presence: true
end
