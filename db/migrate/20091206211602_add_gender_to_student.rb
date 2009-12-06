class AddGenderToStudent < ActiveRecord::Migration
  def self.up
    add_column :students, :gender, :string
  end

  def self.down
    remove_column :students, :gender
  end
end
