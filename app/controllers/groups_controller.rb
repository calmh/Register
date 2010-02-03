class GroupsController < ApplicationController
  before_filter :require_groups_permission

  def index
    @groups = Group.find(:all, :order => :identifier)
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(params[:group])

    if @group.save
      flash[:notice] = t:Group_created
      redirect_to(groups_path)
    else
      render :action => "new"
    end
  end

  def update
    @group = Group.find(params[:id])
    other = Group.find(params[:group][:id])

    if other.id != @group.id
      @group.merge_into(other)
      redirect_to(groups_path)
    else
      if @group.update_attributes(params[:group])
        flash[:notice] = t:Group_updated
        redirect_to(groups_path)
      else
        render :action => "edit"
      end
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    redirect_to(groups_path)
  end

  private
end
