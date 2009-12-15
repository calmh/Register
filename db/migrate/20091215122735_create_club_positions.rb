class CreateClubPositions < ActiveRecord::Migration
  def self.up
    create_table :club_positions do |t|
      t.string :position

      t.timestamps
    end
  end

  def self.down
    drop_table :club_positions
  end
end
