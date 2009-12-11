class ClubsController < ApplicationController
	before_filter :require_user
	before_filter :require_clubs_permission, :only => [ :new, :edit, :create, :destroy, :update ]

	# GET /clubs
	# GET /clubs.xml
	def index
		# @clubs = Club.find(:all)
		@clubs = current_user.clubs

		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @clubs }
		end
	end

	# GET /clubs/1
	# GET /clubs/1.xml
	def show
		redirect_to(:controller => 'students', :action => 'index', :club_id => params[:id]) and return
	end

	# GET /clubs/new
	# GET /clubs/new.xml
	def new
		@club = Club.new

		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @club }
		end
	end

	# GET /clubs/1/edit
	def edit
		@club = Club.find(params[:id])
	end

	# POST /clubs
	# POST /clubs.xml
	def create
		@club = Club.new(params[:club])

		respond_to do |format|
			if @club.save
				flash[:notice] = t:Club_created
				format.html { redirect_to(@club) }
				format.xml  { render :xml => @club, :status => :created, :location => @club }
			else
				format.html { render :action => "new" }
				format.xml  { render :xml => @club.errors, :status => :unprocessable_entity }
			end
		end
	end

	# PUT /clubs/1
	# PUT /clubs/1.xml
	def update
		@club = Club.find(params[:id])

		respond_to do |format|
			if @club.update_attributes(params[:club])
				flash[:notice] = t:Club_updated
				format.html { redirect_to(@club) }
				format.xml  { head :ok }
			else
				format.html { render :action => "edit" }
				format.xml  { render :xml => @club.errors, :status => :unprocessable_entity }
			end
		end
	end

	# DELETE /clubs/1
	# DELETE /clubs/1.xml
	def destroy
		@club = Club.find(params[:id])
		@club.destroy

		respond_to do |format|
			format.html { redirect_to(clubs_url) }
			format.xml  { head :ok }
		end
	end
end
