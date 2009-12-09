class UsersController < ApplicationController
	before_filter :require_user

	# GET /users
	# GET /users.xml
	def index
		@users = User.find(:all)

		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @users }
		end
	end

	# GET /users/1
	# GET /users/1.xml
	def show
		@user = User.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.xml  { render :xml => @user }
		end
	end

	# GET /users/new
	# GET /users/new.xml
	def new
		@user = User.new

		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @user }
		end
	end

	# GET /users/1/edit
	def edit
		@user = User.find(params[:id])
	end

	# POST /users
	# POST /users.xml
	def create
		@user = User.new(params[:user])

		respond_to do |format|
			if @user.save
				flash[:notice] = 'User was successfully created.'
				format.html { redirect_to(@user) }
				format.xml  { render :xml => @user, :status => :created, :location => @user }
			else
				format.html { render :action => "new" }
				format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
			end
		end
	end

	# PUT /users/1
	# PUT /users/1.xml
	def update
		@user = User.find(params[:id])

		# Check all existing permissions to see if we should keep them
		if !@user.permissions.blank?
			@user.permissions.each do |p|
				c_id = p.club_id.to_s
				if !params.key?(:permission) || !params[:permission].key?(c_id) || !params[:permission][c_id].key?(p.permission)
					p.destroy
				end
			end
		end

		if params.key? :permission
			params[:permission].each_key do |club_id|
				permissions = params[:permission][club_id]
				current_perms = @user.permissions_for Club.find(club_id)
				permissions.each_key do |perm|
					if !current_perms.include? perm
						np = Permission.new
						np.club_id = club_id.to_i
						np.user = @user
						np.permission = perm
						np.save!
					end
				end
			end
		end

		respond_to do |format|
			if @user.update_attributes(params[:user])
				flash[:notice] = 'User was successfully updated.'
				format.html { redirect_to(@user) }
				format.xml  { head :ok }
			else
				format.html { render :action => "edit" }
				format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
			end
		end
	end

	# DELETE /users/1
	# DELETE /users/1.xml
	def destroy
		@user = User.find(params[:id])
		@user.destroy

		respond_to do |format|
			format.html { redirect_to(users_url) }
			format.xml  { head :ok }
		end
	end
end
