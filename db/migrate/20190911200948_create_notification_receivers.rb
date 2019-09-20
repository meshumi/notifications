class CreateNotificationReceivers < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_receivers do |t|
      t.string :p256dh
      t.string :auth
      t.string :endpoint
      t.belongs_to :domain, index: true

      t.timestamps
    end
  end
end
