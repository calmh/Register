class AddDefaultToMailingLists < ActiveRecord::Migration
  def self.up
    add_column :mailing_lists, :default, :integer
  end

  def self.down
    remove_column :mailing_lists, :default
  end
end
