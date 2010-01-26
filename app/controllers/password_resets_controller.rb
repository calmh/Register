class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user, :only => [ :new, :edit ]

  def new
    render
  end

  def create
    @user = User.find_by_login_or_email(params[:password_reset][:login])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = t(:Mailed_reset_instruction)
      redirect_to new_user_session_path
    else
      flash[:notice] = t(:No_user_found)
      render :action => :new
    end
  end

  def edit
    render
  end

  def update
    data = params[:student]
    data = params[:administrator] if data.nil?
    @user.password = data[:password]
    @user.password_confirmation = data[:password_confirmation]
    if @user.save
      flash[:notice] = t(:Password_updated)
      redirect_to root_url
    else
      render :action => :edit
    end
  end

  private
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = t(:Could_not_load_account)
      redirect_to root_url
    end
  end
end
