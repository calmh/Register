class CreateBoardPositions < ActiveRecord::Migration
  def self.up
    create_table :board_positions do |t|
      t.string :position

      t.timestamps
    end
  end

  def self.down
    drop_table :board_positions
  end
end
