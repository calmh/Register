class GraduationsController < ApplicationController
  before_filter :require_user

  # GET /graduations
  # GET /graduations.xml
  def index
    @student = Student.find(params[:student_id])
    @club = @student.club
    @graduations = @student.graduations

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @graduations }
    end
  end

  # GET /graduations/1
  # GET /graduations/1.xml
  def show
    @graduation = Graduation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @graduation }
    end
  end

  def new_bulk
    @graduation = Graduation.new
	@students = Student.find(session[:selected_students]);
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @graduation }
    end
  end

  def update_bulk
	@students = Student.find(session[:selected_students]);
	@students.each do |s|
		s.graduations << Graduation.new(params[:graduation])
		s.save
	end
	session[:selected_students] = nil
	redirect_to session[:before_bulk]
  end

  # GET /graduations/new
  # GET /graduations/new.xml
  def new
    @student = Student.find(params[:student_id])
    @graduation = Graduation.new
    @graduation.student = @student

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @graduation }
    end
  end

  # GET /graduations/1/edit
  def edit
    @graduation = Graduation.find(params[:id])
  end

  # POST /graduations
  # POST /graduations.xml
  def create
    @graduation = Graduation.new(params[:graduation])
    @graduation.save
    redirect_to :action => :index
  end

  # PUT /graduations/1
  # PUT /graduations/1.xml
  def update
    @graduation = Graduation.find(params[:id])

    respond_to do |format|
      if @graduation.update_attributes(params[:graduation])
        format.html { redirect_to(@graduation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @graduation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /graduations/1
  # DELETE /graduations/1.xml
  def destroy
    @graduation = Graduation.find(params[:id])
    @graduation.destroy

    respond_to do |format|
      format.html { redirect_to(graduations_url) }
      format.xml  { head :ok }
    end
  end
end
