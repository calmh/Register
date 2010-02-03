class GraduationsController < ApplicationController
  before_filter :require_administrator

  def index
    @student = Student.find(params[:student_id])
    @club = @student.club
    @graduations = @student.graduations

    @graduation = default_graduation
    @graduation.student = @student
  end

  def show
    @graduation = Graduation.find(params[:id])
  end

  def new_bulk
    @graduation = default_graduation
    @students = Student.find(session[:selected_students]);
  end

  def update_bulk
    @students = Student.find(session[:selected_students]);
    @students.each do |student|
      student.graduations << Graduation.new(params[:graduation])
      student.save
    end
    session[:selected_students] = nil

    @graduation = Graduation.new(params[:graduation])
    update_defaults

    redirect_to session[:before_bulk]
  end

  def create
    @graduation = Graduation.new(params[:graduation])
    @graduation.save
    update_defaults

    redirect_to :action => :index
  end

  def update
    @graduation = Graduation.find(params[:id])
    update_defaults

    if @graduation.update_attributes(params[:graduation])
      redirect_to(@graduation)
    else
      render :action => "edit"
    end
  end

  def destroy
    @graduation = Graduation.find(params[:id])
    @graduation.destroy

    redirect_to(graduations_path)
  end

  private

  def update_defaults
    set_default(:graduation_grade, @graduation.grade)
    set_default(:graduation_instructor, @graduation.instructor)
    set_default(:graduation_examiner, @graduation.examiner)
    set_default(:graduation_graduated, @graduation.graduated.to_s)
  end

  def default_graduation
    Graduation.new(:grade_id => get_default(:graduation_grade_id),
    :grade_category_id => get_default(:graduation_grade_category_id),
    :instructor => get_default(:graduation_instructor),
    :examiner => get_default(:graduation_examiner),
    :graduated => DateTime.parse(get_default(:graduation_graduated) || Date.today.to_s))
  end
end
