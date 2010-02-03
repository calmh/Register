class PaymentsController < ApplicationController
  before_filter :require_administrator

  def index
    @student = Student.find(params[:student_id])
    @club = @student.club
    @payments = @student.payments
    @payment = Payment.new(:student_id => @student.id,
      :received => DateTime.parse(get_default(:payment_received) || DateTime.now.to_s),
      :amount => get_default(:payment_amount),
      :description => get_default(:payment_description))
  end

  def edit
    @payment = Payment.find(params[:id])
  end

  def create
    params[:payment][:amount].sub!(",", ".") # Handle Swedish decimal comma in an ugly way
    @payment = Payment.new(params[:payment])
    @payment.save!
    update_defaults

    redirect_to :action => :index
  end

  def update
    @payment = Payment.find(params[:id])

    if @payment.update_attributes(params[:payment])
      redirect_to(@payment)
    else
      render :action => "edit"
    end
  end

  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy

    redirect_to(payments_path)
  end

  private

  def update_defaults
    set_default(:payment_amount, @payment.amount)
    set_default(:payment_description, @payment.description)
    set_default(:payment_received, @payment.received)
  end
end
