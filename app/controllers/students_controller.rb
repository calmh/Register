class SearchParams
  attr_accessor :group_id
  attr_accessor :grade
  attr_accessor :club_id
  attr_accessor :title_id
  attr_accessor :board_position_id
  attr_accessor :club_position_id
  attr_accessor :only_active
  attr_accessor :sort_field
  attr_accessor :sort_order

  def initialize(params = nil)
    if params.key? :ci
      @club_id = params[:ci].map{ |x| x.to_i }
    else
      @club_id = Club.all.map { |c| c.id }
    end

    if !params[:c].blank?
      @sort_field = params[:c]
    else
      @sort_field = params[:c] = 'name'
    end

    if !params[:d].blank?
      @sort_order = params[:d]
    else
      @sort_order = params[:d] = 'up'
    end

    @group_id = int_or_nil(params[:gi])
    @grade = int_or_nil(params[:gr])
    @title_id = int_or_nil(params[:ti])
    @board_position_id = int_or_nil(params[:bp])
    @club_position_id = int_or_nil(params[:cp])
    @only_active = (params[:a].to_i == 1)
  end

  def conditions
    variables = []
    conditions = []

    if @club_id.respond_to?(:each)
      conditions << "club_id in (?)"
      variables << @club_id
    elsif !@club_id.nil?
      conditions << "club_id = ?"
      variables << @club_id
    end

    if !@title_id.nil?
      conditions << "title_id = ?"
      variables << @title_id
    end

    if !@board_position_id.nil?
      conditions << "board_position_id = ?"
      variables << @board_position_id
    end

    if !@club_position_id.nil?
      conditions << "club_position_id = ?"
      variables << @club_position_id
    end

    return [ conditions.join(" AND ") ] + variables
  end

  def sort(students)
    if @sort_field.nil? || @sort_order.nil?
      return students
    else
      return students.sort { |a, b| compare(a, b) }
    end
  end

  def filter(students)
    matched = students

    if !@grade.nil?
      matched = matched.select { |s| s.current_grade != nil && s.current_grade.grade_id == @grade }
    end

    if !@group_id.nil?
      @group_id = @group_id.to_i
      matched = matched.select { |s| s.group_ids.include? @group_id }
    end

    if @only_active
      matched = matched.select { |s| s.active? }
    end

    return sort(matched)
  end

  private

  def int_or_nil(val)
    return nil if val.blank?
    return val.to_i
  end

  def compare(a, b)
    af = a.send(@sort_field)
    bf = b.send(@sort_field)
    if !af.nil? && !bf.nil?
      r = af <=> bf
    elsif af.nil? && !bf.nil?
      r = -1
    elsif !af.nil? && bf.nil?
      r = 1
    else
      r = 0
    end
    r = -r if @sort_order == 'down'
    r
  end
end

class StudentsController < ApplicationController
  before_filter :require_administrator, :except => [ :register, :edit, :update ]
  before_filter :require_student_or_administrator, :only => [ :edit, :update ]
  before_filter :load_searchparams, :only => [ :index ]

  def index
    if !params[:club_id].blank?
      @club = Club.find(params[:club_id])
      @searchparams.club_id = @club.id
      @displayPaymentField = true
      @displayClubField = false
    else
      @clubs = Club.all
      @displayPaymentField = false
      @displayClubField = true
    end
    @students = @searchparams.filter Student.all_inclusive(@searchparams.conditions)

    respond_to do |format|
      format.html # index.html
      format.csv  do
        if @club.nil? || require_export_permission(@club)
          send_data(students_csv, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=export.csv")
          return
        end
      end
    end
  end

  def load_searchparams
    @searchparams = SearchParams.new(params)
  end

  def show
    @student = Student.find(params[:id])
    @club = @student.club
  end

  def new
    @club = Club.find(params[:club_id])
    @student = Student.new
    @student.club = @club
    @student.mailing_lists = MailingList.find_all_by_default_and_club_id(1, nil) + MailingList.find_all_by_default_and_club_id(1, @club.id)
    @student.groups = Group.find(:all, :conditions => { :default => 1 })
  end

  def edit
    @student = Student.find(params[:id])
    require_administrator_or_self(@student)
    @club = @student.club
  end

  def create
    @student = Student.new(params[:student])

    # This is an ugly hack that uses the random perishable token as a base password for the user.
    @student.reset_perishable_token!
    @student.password = @student.password_confirmation = @student.perishable_token
    @student.reset_perishable_token!

    @club = @student.club

    if params.key? :member_of
      group_ids = params[:member_of].keys
      @student.group_ids = group_ids
    end

    if params.key? :subscribes_to
      ml_ids = params[:subscribes_to].keys
      @student.mailing_list_ids = ml_ids
    end

    if @student.save
      flash[:notice] = t:Student_created
      redirect_to(@student)
    else
      render :action => "new"
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

    success = @student.update_attributes(params[:student])

    if current_user.type == 'Administrator'
      flash[:notice] = t(:Student_updated) if success
      redirect = student_path(@student)
    elsif current_user.type == 'Student'
      flash[:notice] = t(:Self_updated) if success
      redirect = edit_student_path(@student)
    end

    if success
      redirect_to redirect
    else
      render :action => "edit"
    end
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy
    redirect_to(@student.club)
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
    if operation == "bulk_message"
      redirect_to :controller => 'messages', :action => 'new'
    end
  end

  def register
    @student = Student.new
  end

  private
  def students_csv
    csv_string = FasterCSV.generate do |csv|
      csv << ["id", "first_name", "last_name", "groups", "personal_number", "gender", "main_interest", "email", "mailing_lists", "home_phone", "mobile_phone", "address", "title", "board_position", "club_position", "comments", "grade", "graduated", "payment_recieved", "payment_amount", "payment_description"]
      @students.each do |user|
        csv << [user.id, user.fname, user.sname, user.groups.map{|g| g.identifier}.join(","), user.personal_number, user.gender, user.main_interest.category, user.email, user.mailing_lists.map{|m| m.email}.join(","), user.home_phone, user.mobile_phone, user.street, user.title.title, user.board_position.position, user.club_position.position, user.comments, user.current_grade.try(:grade).try(:description), user.current_grade.try(:graduated), user.latest_payment.try(:received), user.latest_payment.try(:amount),  user.latest_payment.try(:description)]
      end
    end
    return csv_string
  end
end
