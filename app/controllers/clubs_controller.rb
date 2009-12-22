class ClubsController < ApplicationController
	before_filter :require_administrator
	before_filter :require_clubs_permission, :only => [ :new, :edit, :create, :destroy, :update ]

	def index
		@clubs = current_user.clubs.find(:all, :order => 'name')

		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @clubs }
		end
	end

	def show
		redirect_to(:controller => 'students', :action => 'index', :club_id => params[:id]) and return
	end

	def new
		@club = Club.new

		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @club }
		end
	end

	def edit
		@club = Club.find(params[:id])
	end

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

	def destroy
		@club = Club.find(params[:id])
		@club.destroy

		respond_to do |format|
			format.html { redirect_to(clubs_path) }
			format.xml  { head :ok }
		end
	end
end
