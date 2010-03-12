class Group < ActiveRecord::Base
  has_and_belongs_to_many :students, :order => "sname, fname"

  def merge_into(destination)
    merge_ids = destination.student_ids
    self.students.each do |student|
      destination.students << student unless merge_ids.include?(student.id)
    end
    destination.save!
    destroy
  end
end
