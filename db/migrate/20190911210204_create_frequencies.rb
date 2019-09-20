class CreateFrequencies < ActiveRecord::Migration[6.0]
  def change
    create_table :frequencies do |t|
      t.belongs_to :domain
      t.integer :period
      t.datetime :starting_at
      t.boolean :start_posting, default: false

      t.timestamps
    end
  end
end
