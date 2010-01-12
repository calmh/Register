# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class SiteSettings
  def self.get_setting(setting)
    s = ConfigurationSetting.find(:first, :conditions => { :setting => setting })
    return "" if s == nil
    return s.value
  end

  def self.set_setting(setting, value)
    s = ConfigurationSetting.find(:first, :conditions => { :setting => setting })
    if s == nil
      s = ConfigurationSetting.new
      s.setting = setting
    end
    s.value = value
    s.save!
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
end

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  before_filter :set_locale
  protect_from_forgery # :secret => '4250e2ff2a2308b6668755ef76677cbb'

  def set_locale
    session[:locale] = params[:locale] if params[:locale] != nil
    I18n.locale = session[:locale] if session[:locale] != nil
  end

  def edit_site_settings
    @available_themes = Dir.entries("public/stylesheets/themes").select { |d| !d.starts_with? '.' }.sort
  end

  def update_site_settings
    SiteSettings.site_name = params[:site_name]
    SiteSettings.site_theme = params[:site_theme]
    expire_fragment('layout_header')
    flash[:notice] = t(:Site_settings_updated)
    redirect_to :controller => 'application', :action => 'edit_site_settings'
  end

  def validate
    require_administrator  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def denied
    store_location
    flash[:warning] = t(:Must_log_in)
    current_user_session.destroy if current_user_session
    redirect_to new_user_session_path
    return false
  end

  def require_student_or_administrator
    return denied unless current_user
  end

  def require_administrator_or_self(student)
    return denied unless current_user.type == 'Administrator' || current_user == student
  end

  def require_administrator
    return denied unless current_user && current_user.type == 'Administrator'
  end

  def require_clubs_permission
    return denied unless current_user
    return denied unless current_user.clubs_permission?
  end

  def require_groups_permission
    return denied unless current_user
    return denied unless current_user.groups_permission?
  end

  def require_users_permission
    return denied unless current_user
    return denied unless current_user.users_permission?
  end

  def require_mailing_lists_permission
    return denied unless current_user
    return denied unless current_user.mailinglists_permission?
  end

  def require_no_user
    if current_user
      store_location
      redirect_to current_user
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def get_default(key)
    val = DefaultValue.find(:first, :conditions => { :user_id => current_user.id, :key => key })
    return val.value if val != nil
    return nil
  end

  def set_default(key, value)
    val = DefaultValue.find(:first, :conditions => { :user_id => current_user.id, :key => key })
    if val == nil
      val = DefaultValue.new
      val.user_id = current_user.id
      val.key = key
    end
    val.value = value
    val.save!
  end
end
