class MessagesController < ApplicationController
  def new
    @message = Message.new
    @message.from = current_user.email
    @message.subject = get_default(:message_subject)
    @message.body = get_default(:message_body)
    @students = Student.find(session[:selected_students]);
  end

  def update
    @message = Message.new
    @message.from = current_user.email
    @message.body = params[:message][:body]
    @message.subject = params[:message][:subject]
    @students = Student.find(session[:selected_students]);
    @sent = []
    @noemail = []
    @students.each do |s|
      if s.email.blank?
        @noemail << s
      else
        @sent << s if s.deliver_generic_message!(@message)
      end
    end
    session[:selected_students] = nil

    set_default(:message_subject, @message.subject)
    set_default(:message_body, @message.body)
  end
end
