class CreateGradesTable < ActiveRecord::Migration
  def self.up
	create_table "grades" do |t|
		t.column "description", :string
		t.column "level", :integer
	end
  end

  def self.down
	drop_table "grades"
  end
end
