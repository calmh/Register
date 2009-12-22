class GroupsController < ApplicationController
	before_filter :require_groups_permission

	# GET /groups
	# GET /groups.xml
	def index
		@groups = Group.find(:all, :order => :identifier)

		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @groups }
		end
	end

	# GET /groups/new
	# GET /groups/new.xml
	def new
		@group = Group.new

		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @group }
		end
	end

	# GET /groups/1/edit
	def edit
		@group = Group.find(params[:id])
	end

	# POST /groups
	# POST /groups.xml
	def create
		@group = Group.new(params[:group])

		respond_to do |format|
			if @group.save
				flash[:notice] = t:Group_created
				format.html { redirect_to(groups_path) }
				format.xml  { render :xml => @group, :status => :created, :location => @group }
			else
				format.html { render :action => "new" }
				format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
			end
		end
	end

	# PUT /groups/1
	# PUT /groups/1.xml
	def update
		@group = Group.find(params[:id])
		merge_with = Group.find(params[:group][:id])
		merge_ids = merge_with.student_ids

		if merge_with.id != @group.id
			@group.students.each do |s|
				merge_with.students<<s unless merge_ids.include? s.id
			end
			merge_with.save!
			@group.destroy
			redirect_to(groups_path)
		else
			respond_to do |format|
				if @group.update_attributes(params[:group])
					flash[:notice] = t:Group_updated
					format.html { redirect_to(groups_path) }
					format.xml  { head :ok }
				else
					format.html { render :action => "edit" }
					format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
				end
			end
		end
	end

	# DELETE /groups/1
	# DELETE /groups/1.xml
	def destroy
		@group = Group.find(params[:id])
		@group.destroy

		respond_to do |format|
			format.html { redirect_to(groups_path) }
			format.xml  { head :ok }
		end
	end
end
