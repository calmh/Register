# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

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

	def validate
		require_user
	end

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
		redirect_to new_user_session_url
		return false
	end

	def require_user
		return denied unless current_user
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
