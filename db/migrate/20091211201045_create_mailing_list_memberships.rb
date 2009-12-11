class CreateMailingListMemberships < ActiveRecord::Migration
  def self.up
    create_table :mailing_list_memberships do |t|
      t.integer :student_id
      t.integer :mailing_list_id

      t.timestamps
    end
  end

  def self.down
    drop_table :mailing_list_memberships
  end
end
