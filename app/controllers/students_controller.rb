class SearchParams
	attr_accessor :group_id
	attr_accessor :grade
	attr_accessor :club_id
	attr_accessor :title_id
	attr_accessor :board_position_id
	attr_accessor :club_position_id

	def initialize
		@group_id = -100
		@grade = -100
		@club_id = Club.find(:all).map { |c| c.id }
		@title_id = -100
		@board_position_id = -100
		@club_position_id = -100
	end

	def conditions
		variables = []
		conditions = []
		conditions << "club_id in (?)"
		variables << @club_id
		if title_id != -100
			conditions << "title_id = ?"
			variables << @title_id
		end
		if board_position_id != -100
			conditions << "board_position_id = ?"
			variables << @board_position_id
		end
		if club_position_id != -100
			conditions << "club_position_id = ?"
			variables << @club_position_id
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

class StudentsController < ApplicationController
	before_filter :require_administrator, :except => [ :register, :edit, :update ]
	before_filter :require_student_or_administrator, :only => [ :edit, :update ]

	def index
		@only_active = get_default(:only_active)

		@club = Club.find(params[:club_id])
		@students = Student.find(:all, :include => [ "graduations", "payments", "club", "groups", "main_interest", "board_position", "club_position", "title" ], :conditions => { :club_id => @club.id })

		if @only_active == 'yes'
			@students = @students.select { |s| s.active? }
		end

		respond_to do |format|
			format.html # index.html
			format.xml  { render :xml => @students }
		end
	end

	def filter
		@searchparams = SearchParams.new
		if params.key? :searchparams
			@searchparams.group_id = params[:searchparams][:group_id].to_i
			@searchparams.grade = params[:searchparams][:grade].to_i
			@searchparams.title_id = params[:searchparams][:title_id].to_i
			@searchparams.board_position_id = params[:searchparams][:board_position_id].to_i
			@searchparams.club_position_id = params[:searchparams][:club_position_id].to_i
			set_default(:only_active, params[:searchparams][:only_active])
		end
		@searchparams = SearchParams.new if @searchparams == nil
		@only_active = get_default(:only_active)

		@club = Club.find(params[:club_id])
		@students = @searchparams.filter(@club.students.find(:all, :conditions => @searchparams.conditions, :order => "fname, sname"))

		if @only_active == 'yes'
			@students = @students.select { |s| s.active? }
		end

		respond_to do |format|
			format.html { render :index }
			format.xml  { render :xml => @students }
		end
	end

	def search
		@searchparams = SearchParams.new
		if params.key? :searchparams
			@searchparams.group_id = params[:searchparams][:group_id].to_i
			@searchparams.grade = params[:searchparams][:grade].to_i
			@searchparams.club_id = params[:searchparams][:club_id].map{|x| x.to_i}
			@searchparams.title_id = params[:searchparams][:title_id].to_i
			@searchparams.board_position_id = params[:searchparams][:board_position_id].to_i
			@searchparams.club_position_id = params[:searchparams][:club_position_id].to_i
			set_default(:only_active, params[:searchparams][:only_active])
		end
		@only_active = get_default(:only_active)

		@clubs = Club.find(:all, :order => :name)
		@students = @searchparams.filter(Student.find(:all, :include => [ "graduations", "payments", "club", "groups", "main_interest", "board_position", "club_position", "title" ], :conditions => @searchparams.conditions, :order => "fname, sname"))
		if @only_active == 'yes'
			@students = @students.select { |s| s.active? }
		end

		respond_to do |format|
			format.html
			format.xml  { render :xml => @student }
		end
	end

	def show
		@student = Student.find(params[:id])
		@club = @student.club

		respond_to do |format|
			format.html # show.html.erb
			format.xml  { render :xml => @student }
		end
	end

	def new
		@club = Club.find(params[:club_id])
		@student = Student.new
		@student.club = @club
		@student.mailing_lists = MailingList.find(:all, :conditions => { :default => 1 })
		@student.groups = Group.find(:all, :conditions => { :default => 1 })

		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @student }
		end
	end

	def edit
		@student = Student.find(params[:id])
		require_administrator_or_self(@student)
		@club = @student.club
	end

	def create
		@student = Student.new(params[:student])
		@club = @student.club

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

	def update
		@student = Student.find(params[:id])
		require_administrator_or_self(@student)
		@club = @student.club

		if current_user.type == 'Administrator' && params.key?(:member_of)
			group_ids = params[:member_of].keys
			@student.group_ids = group_ids
		else
			@student.groups.clear
		end

		# TODO: This is insecure, a student could potentially join a mailing list they shouldn't by editing hidden fields.
		if params.key? :subscribes_to
			ml_ids = params[:subscribes_to].keys
			@student.mailing_list_ids = ml_ids
		else
			@student.mailing_lists.clear
		end

		if current_user.type == 'Administrator'
			respond_to do |format|
				if @student.update_attributes(params[:student])
					flash[:notice] = t(:Student_updated)
					format.html { redirect_to(@student) }
					format.xml  { head :ok }
				else
					format.html { render :action => "edit" }
					format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
				end
			end
		elsif current_user.type == 'Student'
			respond_to do |format|
				if @student.update_attributes(params[:student])
					flash[:notice] = t(:Self_updated)
					format.html { redirect_to edit_student_path(@student) }
					format.xml  { head :ok }
				else
					format.html { render :action => "edit" }
					format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
				end
			end
		end
	end

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
