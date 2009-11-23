class User < ActiveRecord::Base
  has_many :permissions
  acts_as_authentic do |c|
    Authlogic::CryptoProviders::Sha1.stretches = 1
    c.transition_from_crypto_providers = Authlogic::CryptoProviders::Sha1
    c.crypto_provider = Authlogic::CryptoProviders::Sha256
  end
end
