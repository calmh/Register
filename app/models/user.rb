class User < ActiveRecord::Base
  has_many :permissions
  acts_as_authentic do |c|
    Authlogic::CryptoProviders::Sha1.stretches = 1
    c.transition_from_crypto_providers = Authlogic::CryptoProviders::Sha1
    c.crypto_provider = Authlogic::CryptoProviders::Sha256
    c.validates_length_of_login_field_options = { :in => 2..20 }
  end

  def edit_club_permission?(club)
    return club.name == "Lund"
    # return true if clubs_permission?
  end
  def graduations_permission?(club)
    return club.name == "Lund"
    # return true if clubs_permission?
  end
  def payments_permission?(club)
    return club.name == "Lund"
    # return true if clubs_permission?
  end
end

