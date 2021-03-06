class Notifier < ActionMailer::Base
  default_url_options[:host] = "www.fiveforms.org"

  def password_reset_instructions(user)
    subject "Password Reset Instructions"
    from "webmaster@fiveforms.org"
    recipients user.email
    sent_on Time.now
    body :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end

  def generic_message(user, message)
    subject message.subject
    from message.from
    recipients user.email
    sent_on Time.now
    body message.body
  end
end
