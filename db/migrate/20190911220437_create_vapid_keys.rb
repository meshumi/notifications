class CreateVapidKeys < ActiveRecord::Migration[6.0]
  def up
    create_table :vapid_keys do |t|
      t.string :public_key
      t.string :private_key

      t.timestamps null: false
    end

    vapid_key = Webpush.generate_key

    VapidKey.create(public_key: vapid_key.public_key, private_key: vapid_key.private_key)
  end

  def down
    drop_table :vapid_keys
  end
end
