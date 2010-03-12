class SiteSettings
  def self.get_setting(setting_name)
    setting = ConfigurationSetting.find(:first, :conditions => { :setting => setting_name })
    return "" if setting == nil
    return setting.value
  end

  def self.set_setting(setting_name, value)
    setting = ConfigurationSetting.find(:first, :conditions => { :setting => setting_name })
    if setting == nil
      setting = ConfigurationSetting.new
      setting.setting = setting_name
    end
    setting.value = value
    setting.save!
  end

  def self.site_name
    get_setting(:site_name)
  end
  def self.site_name=(value)
    set_setting(:site_name, value)
  end

  def self.site_theme
    get_setting(:site_theme)
  end
  def self.site_theme=(value)
    set_setting(:site_theme, value)
  end

  def self.welcome_text
    get_setting(:welcome_text)
  end
  def self.welcome_text=(value)
    set_setting(:welcome_text, value)
  end
end

