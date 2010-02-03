class ClubsController < ApplicationController
  before_filter :require_administrator
  before_filter :require_clubs_permission, :only => [ :new, :edit, :create, :destroy, :update ]

  def index
    @clubs = current_user.clubs.find(:all, :order => 'name')
  end

  def show
    redirect_to(:controller => 'students', :action => 'index', :club_id => params[:id]) and return
  end

  def new
    @club = Club.new
  end

  def edit
    @club = Club.find(params[:id])
  end

  def create
    @club = Club.new(params[:club])

    if @club.save
      flash[:notice] = t:Club_created
      redirect_to(@club)
    else
      render :action => "new"
    end
  end

  def update
    @club = Club.find(params[:id])

    if @club.update_attributes(params[:club])
      flash[:notice] = t:Club_updated
      redirect_to(@club)
    else
      render :action => "edit"
    end
  end

  def destroy
    @club = Club.find(params[:id])
    @club.destroy

    redirect_to(clubs_path)
  end
end
