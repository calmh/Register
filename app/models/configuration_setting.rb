class ConfigurationSetting < ActiveRecord::Base
	validates_presence_of :setting, :value
	validates_uniqueness_of :setting
end
