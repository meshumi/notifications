# frozen_string_literal: true
namespace :send do
  task :notifications => :environment do
    Domain.find_each do |domain|
      frequency = domain.frequency
      next unless frequency.start_posting?

      last_posted =  domain.posts.already_posted.except_posted_manual.where('posted_at > ?', frequency.updated_at).order(posted_at: :desc).first

      if (last_posted.blank? && frequency.starting_at < Time.now) || (last_posted.posted_at + frequency.time_between_posts) > Time.now
        post = domain.posts.in_queue.oldest_first.first
        if post
          NotifyService.new(domain, post).send_notification
        else
          frequency.update(start_posting: false)
        end
      end
    end
  end
end

