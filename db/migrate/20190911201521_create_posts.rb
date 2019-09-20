class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.belongs_to :domain, index: true
      t.string :title
      t.string :message
      t.boolean :post_after_create, default: false
      t.boolean :posted, default: false
      t.datetime :posted_at

      t.timestamps
    end
  end
end
