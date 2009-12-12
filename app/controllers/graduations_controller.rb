class GraduationsController < ApplicationController
	before_filter :require_user

	# GET /graduations
	# GET /graduations.xml
	def index
		@student = Student.find(params[:student_id])
		@club = @student.club
		@graduations = @student.graduations

		@graduation = Graduation.new
		@graduation.student = @student
		@graduation.grade = get_default(:graduation_grade)
		@graduation.instructor = get_default(:graduation_instructor)
		@graduation.examiner = get_default(:graduation_examiner)
		@graduation.graduated = DateTime.parse(get_default(:graduation_graduated) || Date.today.to_s)

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
		@graduation.grade = get_default(:graduation_grade)
		@graduation.instructor = get_default(:graduation_instructor)
		@graduation.examiner = get_default(:graduation_examiner)
		@graduation.graduated = DateTime.parse(get_default(:graduation_graduated) || DateTime.now.to_s)
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

		@graduation = Graduation.new(params[:graduation])
		set_default(:graduation_grade, @graduation.grade)
		set_default(:graduation_instructor, @graduation.instructor)
		set_default(:graduation_examiner, @graduation.examiner)
		set_default(:graduation_graduated, @graduation.graduated.to_s)

		redirect_to session[:before_bulk]
	end

	# POST /graduations
	# POST /graduations.xml
	def create
		@graduation = Graduation.new(params[:graduation])
		@graduation.save
		set_default(:graduation_grade, @graduation.grade)
		set_default(:graduation_instructor, @graduation.instructor)
		set_default(:graduation_examiner, @graduation.examiner)
		set_default(:graduation_graduated, @graduation.graduated.to_s)
		redirect_to :action => :index
	end

	# PUT /graduations/1
	# PUT /graduations/1.xml
	def update
		@graduation = Graduation.find(params[:id])
		set_default(:graduation_grade, @graduation.grade)
		set_default(:graduation_instructor, @graduation.instructor)
		set_default(:graduation_examiner, @graduation.examiner)
		set_default(:graduation_graduated, @graduation.graduated.to_s)

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
