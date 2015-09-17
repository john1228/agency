namespace :course do
  desc '计算'
  task :check => :environment do
    ServiceCourse.where('status =1 and limit_start<?', Time.now.utc).each { |service_course|
      service_course.update(status: ServiceCourse::STATUS[:offline])
    }
  end
end