class AddClubIdToMailingList < ActiveRecord::Migration
  def self.up
    add_column :mailing_lists, :club_id, :integer
  end

  def self.down
    remove_column :mailing_lists, :club_id
  end
end
