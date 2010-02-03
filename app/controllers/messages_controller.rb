class MessagesController < ApplicationController
  def new
    @message = Message.new(:from => current_user.email, :subject => get_default(:message_subject), :body => get_default(:message_body))
    @students = Student.find(session[:selected_students]);
  end

  def update
    @message = Message.new(:from => current_user.email, :body => params[:message][:body], :subject => params[:message][:subject])
    @students = Student.find(session[:selected_students])
    session[:selected_students] = nil

    @sent =  @noemail = []
    @students.each do |student|
      if student.email.blank?
        @noemail << s
      else
        student.deliver_generic_message!(@message)
        @sent << student
      end
    end

    set_default(:message_subject, @message.subject)
    set_default(:message_body, @message.body)
  end
end
