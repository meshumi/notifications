class Post < ApplicationRecord
  belongs_to :domain

  validates :title, :message, :domain_id, presence: true

  after_save_commit :posting, if: :need_post_immediately?

  scope :in_queue, -> { where(posted: false) }
  scope :oldest_first, -> { order(created_at: :asc) }
  scope :already_posted, -> { where(posted: true) }
  scope :except_posted_manual, -> { where(post_immediately: false) }

  def posting
    NotifyService.new(domain, self).send_notification
  end

  def need_post_immediately?
    post_after_create? && !posted
  end
end
