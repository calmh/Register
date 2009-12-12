class User < ActiveRecord::Base
	has_many :permissions, :dependent => :destroy
	validates_presence_of :clubs_permission
	validates_presence_of :groups_permission
	validates_presence_of :users_permission
	validates_presence_of :mailinglists_permission
	has_many :clubs, :through => :permissions, :uniq => true

	acts_as_authentic do |c|
		Authlogic::CryptoProviders::Sha1.stretches = 1
		c.transition_from_crypto_providers = Authlogic::CryptoProviders::Sha1
		c.crypto_provider = Authlogic::CryptoProviders::Sha256
		c.validates_length_of_login_field_options = { :in => 2..20 }
	end

	def permissions_for(club)
		permissions.find(:all, :conditions => { :club_id => club.id }).map do
			|perm| perm.permission
		end
	end

	def edit_club_permission?(club)
		permissions_for(club).include? 'edit'
	end

	def delete_permission?(club)
		permissions_for(club).include? 'delete'
	end

	def graduations_permission?(club)
		permissions_for(club).include? 'graduations'
	end

	def payments_permission?(club)
		permissions_for(club).include? 'payments'
	end
end

