class ConfigurationSetting < ActiveRecord::Base
  validates_presence_of :setting
  validates_uniqueness_of :setting
end
