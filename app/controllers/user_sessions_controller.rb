class UserSessionsController < ApplicationController
	before_filter :require_no_user, :only => [:new, :create]
	before_filter :require_user, :only => :destroy

	def new
		@user_session = UserSession.new
	end

	def create
		@user_session = UserSession.new(params[:user_session])
		if @user_session.save
			flash[:notice] = t(:Login_successful)
			@user = @user_session.user
			default = clubs_url
			default = club_url(@user.clubs[0]) if !@user.clubs_permission? && @user.clubs.length == 1
			redirect_to default
		else
			flash[:warning] = t(:Login_invalid)
			redirect_to new_user_session_url
		end
	end

	def destroy
		current_user_session.destroy
		flash[:notice] = t(:Logout_successful)
		redirect_back_or_default new_user_session_url
	end
end

