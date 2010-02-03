class PermissionsController < ApplicationController
  before_filter :require_administrator

  def index
    @permissions = Permission.find(:all)
  end

  def show
    @permission = Permission.find(params[:id])
  end

  def new
    @permission = Permission.new
  end

  def edit
    @permission = Permission.find(params[:id])
  end

  def create
    @permission = Permission.new(params[:permission])

    if @permission.save
      redirect_to(@permission)
    else
      render :action => "new"
    end
  end

  def update
    @permission = Permission.find(params[:id])

    if @permission.update_attributes(params[:permission])
      redirect_to(@permission)
    else
      render :action => "edit"
    end
  end

  def destroy
    @permission = Permission.find(params[:id])
    @permission.destroy

    redirect_to(permissions_path)
  end
end
