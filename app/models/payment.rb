class Payment < ActiveRecord::Base
	belongs_to :student
	validates_numericality_of :amount
	validates_presence_of :amount, :description, :received
end
