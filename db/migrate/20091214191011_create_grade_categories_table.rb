class CreateGradeCategoriesTable < ActiveRecord::Migration
  def self.up
	create_table "grade_categories" do |t|
		t.column "category", :string
	end
  end

  def self.down
	drop_table "grade_categories"
  end
end
