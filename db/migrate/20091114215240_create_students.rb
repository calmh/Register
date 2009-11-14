class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.integer :club_id
      t.string :sname
      t.string :fname
      t.string :personal_number
      t.string :email
      t.string :home_phone
      t.string :mobile_phone
      t.string :street
      t.string :zipcode
      t.string :city
      t.string :title
      t.text :comments
      t.string :password

      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end
end
