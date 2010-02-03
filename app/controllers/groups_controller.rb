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
    merge_with = Group.find(params[:group][:id])

    if merge_with.id != @group.id
      merge_groups(@group, merge_with)
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

  def merge_groups(source, destination)
    merge_ids = destination.student_ids
    @group.students.each do |s|
      destination.students << s unless merge_ids.include? s.id
    end
    destination.save!
    source.destroy
  end
end
