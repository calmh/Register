class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :student_id
      t.float :amount
      t.datetime :received
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
