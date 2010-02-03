class User < ActiveRecord::Base
  acts_as_authentic do |config|
    Authlogic::CryptoProviders::Sha1.stretches = 1
    config.transition_from_crypto_providers = Authlogic::CryptoProviders::Sha1
    config.crypto_provider = Authlogic::CryptoProviders::Sha256
    config.validate_login_field = false
    config.validate_email_field = false
    config.validate_password_field = false
    config.require_password_confirmation = false
  end

  def self.find_by_login_or_email(login)
    User.find_by_login(login) || User.find_by_email(login)
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end

  def deliver_generic_message!(message)
    Notifier.deliver_generic_message(self, message)
  end
end
