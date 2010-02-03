class AdministratorsController < ApplicationController
  before_filter :require_administrator
  before_filter :require_users_permission, :only => [ :destroy, :new, :create, :index ]

  def index
    @admins = Administrator.find(:all)
  end

  def show
    @admin = Administrator.find(params[:id])
    @admin = current_user if @admin == nil
  end

  def new
    @admin = Administrator.new
  end

  def edit
    @admin = Administrator.find(params[:id])
  end

  def create
    @admin = Administrator.new(params[:administrator])

    if @admin.save
      grant_permissions(params[:permission])
      flash[:notice] = t:User_created
      redirect_to(administrators_path)
    else
      render :action => "new"
    end
  end

  def update
    @admin = Administrator.find(params[:id])

    if current_user.users_permission?
      permissions = params[:permission]
      revoke_other_permissions_than(permissions)
      grant_permissions(permissions)
    end

    if @admin.update_attributes(params[:administrator])
      flash[:notice] = t(:User_updated)
      redirect_to(@admin)
    else
      render :action => "edit"
    end
  end

  def destroy
    @admin = User.find(params[:id])
    @admin.destroy
    redirect_to(administrators_path)
  end

  private

  def grant_permissions(perms)
    return if perms.blank?
    perms.each_key do |club_id|
      permissions = perms[club_id]
      current_perms = @admin.permissions_for(Club.find(club_id))
      permissions.each_key do |perm|
        if !current_perms.include? perm
          new_perm = Permission.new(:club_id => club_id, :user => @admin, :permission => perm)
          new_perm.save!
        end
      end
    end
  end

  def revoke_other_permissions_than(perms)
    if !@admin.permissions.blank?
      @admin.permissions.each do |permission|
        c_id = permission.club_id.to_s
        if perms.blank? || !perms.key?(c_id) || !perms[c_id].key?(permission.permission)
          permission.destroy
        end
      end
    end
  end
end
