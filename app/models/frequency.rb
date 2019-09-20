class Frequency < ApplicationRecord
  enum period: { day: 0, hour: 1 }
  belongs_to :domain

  validates :starting_at, :domain_id, presence: true

  def time_between_posts
    if period == 'day'
      1.day
    else
      1.hour
    end
  end
end
