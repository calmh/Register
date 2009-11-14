class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :club_id
      t.string :login
      t.string :sname
      t.string :fname
      t.string :email
      t.string :password

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
