class StudentsController < ApplicationController
	before_filter :require_user, :except => [ :register ]

	class SearchParams
		attr_accessor :group_id
		attr_accessor :grade
		attr_accessor :club_id

		def initialize
			@group_id = -100
			@grade = -100
			@club_id = -100
		end

		def conditions
			variables = []
			conditions = []
			if club_id != -100
				conditions << "club_id = ?"
				variables << @club_id
			end
			return [ conditions.join(" AND ") ] + variables
		end

		def filter(students)
			matched = students
			if grade != -100
				matched = matched.select { |s| s.current_grade != nil && s.current_grade.grade_id == @grade }
			end
			if group_id != -100
				matched = matched.select { |s| s.group_ids.include? group_id }
			end
			return matched
		end
	end

	def index
		@club = Club.find(params[:club_id])
		@students = @club.students

		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @student }
		end
	end

	def search
		@searchparams = SearchParams.new
		if params.key? :searchparams
			@searchparams.group_id = params[:searchparams][:group_id].to_i
			@searchparams.grade = params[:searchparams][:grade].to_i
			@searchparams.club_id = params[:searchparams][:club_id].to_i
		end

		@clubs = Club.find(:all, :order => :name)
		@students = @searchparams.filter(Student.find(:all, :conditions => @searchparams.conditions, :order => "fname, sname"))

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
		@student.club = @club

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

		if params.key? :member_of
			group_ids = params[:member_of].keys
			@student.group_ids = group_ids
		end

		if params.key? :subscribes_to
			ml_ids = params[:subscribes_to].keys
			@student.mailing_list_ids = ml_ids
		end

		respond_to do |format|
			if @student.save
				flash[:notice] = t:Student_created
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

		if params.key? :member_of
			group_ids = params[:member_of].keys
			@student.group_ids = group_ids
		else
			@student.groups.clear
		end

		if params.key? :subscribes_to
			ml_ids = params[:subscribes_to].keys
			@student.mailing_list_ids = ml_ids
		else
			@student.mailing_lists.clear
		end

		respond_to do |format|
			if @student.update_attributes(params[:student])
				flash[:notice] = t:Student_updated
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
			format.html { redirect_to(@student.club) }
			format.xml  { head :ok }
		end
	end

	def bulk_operations
		session[:before_bulk] = request.referer
		session[:selected_students] = params[:selected_students]
		operation = "bulk_message" if params[:bulk_message]
		operation = "bulk_payments" if params[:bulk_payments]
		operation = "bulk_graduations" if params[:bulk_graduations]
		if operation == "bulk_graduations"
			redirect_to :controller => 'graduations', :action => 'new_bulk'
		end
		if operation == "bulk_payments"
			redirect_to :controller => 'graduations', :action => 'new_bulk'
		end
	end

	def register
		@student = Student.new

		respond_to do |format|
			format.html # register.html.erb
			format.xml  { render :xml => @student }
		end
	end
end
