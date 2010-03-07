class MessagesController < ApplicationController
  def new
    @students = Student.find(session[:selected_students]);
    @message = Message.new
    @message.from = current_user.email
    @message.subject = get_default(:message_subject)
    @message.body = get_default(:message_body)
  end

  def update
    @message = Message.new
    @message.from = current_user.email
    @message.body = params[:message][:body]
    @message.subject = params[:message][:subject]
    @students = Student.find(session[:selected_students])
    session[:selected_students] = nil

    @sent =  @noemail = []
    @students.each do |student|
      if student.email.blank?
        @noemail << student
      else
        student.deliver_generic_message!(@message)
        @sent << student
      end
    end

    set_default(:message_subject, @message.subject)
    set_default(:message_body, @message.body)
  end
end
