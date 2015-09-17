class CourseAbstract < ActiveRecord::Base
  belongs_to :course
  belongs_to :address
  belongs_to :coach
end
