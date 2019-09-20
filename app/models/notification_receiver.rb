class NotificationReceiver < ApplicationRecord
  belongs_to :domain

  validates :domain_id, presence: true
end
