class CreateConfigurationSettings < ActiveRecord::Migration
  def self.up
    create_table :configuration_settings do |t|
      t.string :setting
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :configuration_settings
  end
end
