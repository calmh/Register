class AdministratorsController < ApplicationController
		before_filter :require_administrator
		before_filter :require_users_permission, :only => [ :destroy, :new, :create, :index ]

		def index
			@admins = Administrator.find(:all)

			respond_to do |format|
				format.html # index.html.erb
				format.xml  { render :xml => @admins }
			end
		end

		def show
			@admin = Administrator.find(params[:id])
			@admin = current_user if @admin == nil
			respond_to do |format|
				format.html # show.html.erb
				format.xml  { render :xml => @admin }
			end
		end

		def new
			@admin = Administrator.new

			respond_to do |format|
				format.html # new.html.erb
				format.xml  { render :xml => @admin }
			end
		end

		def edit
			@admin = Administrator.find(params[:id])
		end

		def create
			@admin = Administrator.new(params[:administrator])
			success = @admin.save

			if success && params.key?(:permission)
				params[:permission].each_key do |club_id|
					permissions = params[:permission][club_id]
					current_perms = @admin.permissions_for Club.find(club_id)
					permissions.each_key do |perm|
						if !current_perms.include? perm
							np = Permission.new
							np.club_id = club_id.to_i
							np.user = @admin
							np.permission = perm
							np.save!
						end
					end
				end
			end

			respond_to do |format|
				if success
					flash[:notice] = t:User_created
					format.html { redirect_to(administrators_path) }
					format.xml  { render :xml => @admin, :status => :created, :location => @admin }
				else
					format.html { render :action => "new" }
					format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
				end
			end
		end

		def update
			@admin = Administrator.find(params[:id])

			if current_user.users_permission?
				# Check all existing permissions to see if we should keep them
				if !@admin.permissions.blank?
					@admin.permissions.each do |p|
						c_id = p.club_id.to_s
						if !params.key?(:permission) || !params[:permission].key?(c_id) || !params[:permission][c_id].key?(p.permission)
							p.destroy
						end
					end
				end

				if params.key? :permission
					params[:permission].each_key do |club_id|
						permissions = params[:permission][club_id]
						current_perms = @admin.permissions_for Club.find(club_id)
						permissions.each_key do |perm|
							if !current_perms.include? perm
								np = Permission.new
								np.club_id = club_id.to_i
								np.user = @admin
								np.permission = perm
								np.save!
							end
						end
					end
				end
			end

			respond_to do |format|
				if @admin.update_attributes(params[:administrator])
					flash[:notice] = t(:User_updated)
					format.html { redirect_to(@admin) }
					format.xml  { head :ok }
				else
					format.html { render :action => "edit" }
					format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
				end
			end
		end

		def destroy
			@admin = User.find(params[:id])
			@admin.destroy

			respond_to do |format|
				format.html { redirect_to(administrators_path) }
				format.xml  { head :ok }
			end
		end
	end
