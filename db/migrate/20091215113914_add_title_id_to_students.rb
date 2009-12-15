class AddTitleIdToStudents < ActiveRecord::Migration
  def self.up
    add_column :students, :title_id, :integer
    remove_column :students, :title
  end

  def self.down
    remove_column :students, :title_id
    add_column :students, :title, :string
  end
end
