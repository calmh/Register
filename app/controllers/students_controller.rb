class StudentsController < ApplicationController
  before_filter :require_user
  def index
    @club = Club.find(params[:club_id])
    @students = @club.students

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student }
    end
  end

  # GET /students/1
  # GET /students/1.xml
  def show
    @student = Student.find(params[:id])
    @club = @student.club

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end
  end

  # GET /students/new
  # GET /students/new.xml
  def new
    @club = Club.find(params[:club_id])
    @student = Student.new
    # @student.group = @club.groups[0]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student }
    end
  end

  # GET /students/1/edit
  def edit
    @student = Student.find(params[:id])
    @club = @student.club
  end

  # POST /students
  # POST /students.xml
  def create
    @student = Student.new(params[:student])

    respond_to do |format|
      if @student.save
        flash[:notice] = 'Student was successfully created.'
        format.html { redirect_to(@student) }
        format.xml  { render :xml => @student, :status => :created, :location => @student }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /students/1
  # PUT /students/1.xml
  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        flash[:notice] = 'Student was successfully updated.'
        format.html { redirect_to(@student) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.xml
  def destroy
    @student = Student.find(params[:id])
    @student.destroy

    respond_to do |format|
      format.html { redirect_to(students_url) }
      format.xml  { head :ok }
    end
  end

  def bulk_operations
    @students = Student.find(params[:selected_students])
    @operation = "bulk_message" if params[:bulk_message]
    @operation = "bulk_payments" if params[:bulk_payments]
    @operation = "bulk_graduations" if params[:bulk_graduations]
    debugger
  end
end
