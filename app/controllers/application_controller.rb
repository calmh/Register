class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  before_filter :set_locale
  protect_from_forgery
  before_filter :require_site_permission, :only => [ :edit_site_settings, :update_site_settings ]

  def edit_site_settings
    @available_themes = Dir.entries("public/stylesheets/themes").select { |entry| !entry.starts_with? '.' }.sort
    render
  end

  def update_site_settings
    SiteSettings.site_name = params[:site_name]
    SiteSettings.site_theme = params[:site_theme]
    SiteSettings.welcome_text = params[:welcome_text]

    expire_fragment('layout_header')

    flash[:notice] = t(:Site_settings_updated)
    redirect_to :controller => 'application', :action => 'edit_site_settings'
  end

  def set_locale
    session[:locale] = params[:locale] if params[:locale] != nil
    I18n.locale = session[:locale] if session[:locale] != nil
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_student_or_administrator
    return denied unless current_user
    return true
  end

  def require_administrator_or_self(student)
    return denied unless current_user.type == 'Administrator' || current_user == student
    return true
  end

  def require_administrator
    return denied unless current_user && current_user.type == 'Administrator'
    return true
  end

  def require_clubs_permission
    require_permission(:clubs_permission?)
  end

  def require_groups_permission
    require_permission(:groups_permission?)
  end

  def require_users_permission
    require_permission(:users_permission?)
  end

  def require_mailing_lists_permission
    require_permission(:mailinglists_permission?)
  end

  def require_site_permission
    require_permission(:site_permission?)
  end

  def require_export_permission(club)
    return denied unless current_user
    return denied unless current_user.export_permission?(club)
    return true
  end

  def require_no_user
    if current_user
      store_location
      redirect_to current_user
      return false
    end
    return true
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
    val.try(:value)
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

  private

  def require_permission(permission)
    return denied unless current_user
    return denied unless current_user.send(permission)
    return true
  end

  def denied
    store_location
    flash[:warning] = t(:Must_log_in)
    current_user_session.destroy if current_user_session
    redirect_to new_user_session_path
    return false
  end
end
