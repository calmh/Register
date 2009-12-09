class CreateDefaultValues < ActiveRecord::Migration
  def self.up
    create_table :default_values do |t|
      t.integer :user_id
      t.string :key
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :default_values
  end
end
