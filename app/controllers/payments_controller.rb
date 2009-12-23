class PaymentsController < ApplicationController
	before_filter :require_administrator

	def index
		@student = Student.find(params[:student_id])
		@club = @student.club
		@payments = @student.payments
		@payment = Payment.new
		@payment.student_id = @student.id
		@payment.received = DateTime.parse(get_default(:payment_received) || DateTime.now.to_s)
		@payment.amount = get_default(:payment_amount)
		@payment.description = get_default(:payment_description)

		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @payments }
		end
	end

	def edit
		@payment = Payment.find(params[:id])
	end

	def create
		params[:payment][:amount].sub!(",", ".") # Handle Swedish decimal comma in an ugly way
		@payment = Payment.new(params[:payment])
		@payment.save!
		set_default(:payment_amount, @payment.amount)
		set_default(:payment_description, @payment.description)
		set_default(:payment_received, @payment.received)
		redirect_to :action => :index
	end

	def update
		@payment = Payment.find(params[:id])

		respond_to do |format|
			if @payment.update_attributes(params[:payment])
				format.html { redirect_to(@payment) }
				format.xml  { head :ok }
			else
				format.html { render :action => "edit" }
				format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
			end
		end
	end

	def destroy
		@payment = Payment.find(params[:id])
		@payment.destroy

		respond_to do |format|
			format.html { redirect_to(payments_path) }
			format.xml  { head :ok }
		end
	end
end
