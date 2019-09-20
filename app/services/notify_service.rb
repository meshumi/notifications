class NotifyService
  def initialize(domain, post)
    @domain = domain
    @post = post
    @title = @post.title
    @message = @post.message
  end

  def send_notification
    @domain.notification_receivers.find_each do |receiver|
      binding.pry
      Webpush.payload_send(
        message: JSON.generate(json_message),
        endpoint: receiver.endpoint,
        p256dh: receiver.p256dh,
        auth: receiver.auth,
        vapid: {
          subject: "mailto:sender@#{@domain.name}",
          public_key: vapid_key.public_key,
          private_key: vapid_key.private_key
        },
        ssl_timeout: 5,
        open_timeout: 5,
        read_timeout: 5
      )
    end
    mark_post_as_posted
  end

  def vapid_key
    @vapid_key ||= VapidKey.last
  end

  def json_message
    @json_message ||= {
      title: @title,
      body: @message,
    }
  end

  def mark_post_as_posted
    @post.update(posted_at: Time.now, posted: true)
  end
end
