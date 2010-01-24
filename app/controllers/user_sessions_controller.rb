class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_administrator, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      # flash[:notice] = t(:Login_successful)
      @user = @user_session.user
      if @user.type == 'Student'
        default = edit_student_path(@user)
      elsif @user.type == 'Administrator'
        default = clubs_path
        default = club_path(@user.clubs[0]) if !@user.clubs_permission? && @user.clubs.length == 1
      end
      redirect_to default
    else
      flash[:warning] = t(:Login_invalid)
      redirect_to new_user_session_path
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = t(:Logout_successful)
    redirect_to new_user_session_path
  end
end

