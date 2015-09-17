namespace :migration do
  desc '课程转移'
  task :course => :environment do

    Course.all.map { |course|
      service = course.coach.service rescue nil
      if service.present?
        if course.image.blank?
          image = CoursePhoto.where(course_id: course.id).map { |photo| photo.photo }
          course.update(image: image)
        end
      else
        course.update(status: 0)
      end
    }


    Course.all.map { |course|
      service = course.coach.service rescue nil
      sku = Sku.where('course_id = ? and sku LIKE ?', course.id, 'CC%')
      if course.image.first.present? && sku.blank? && service.present?
        Sku.create(
            sku: 'CC'+'-' + '%06d' % course.id + '-' + '%06d' % (service.id),
            course_id: course.id,
            course_type: course.type,
            course_name: course.name,
            course_cover: course.cover,
            course_guarantee: course.guarantee,
            seller: course.coach.profile.name,
            seller_id: course.coach.id,
            market_price: course.price,
            selling_price: course.price,
            address: service.profile.address||'',
            coordinate: (service.place.lonlat rescue 'POINT(0 0)'),
            comments_count: 0,
            orders_count: 0,
            concerns_count: 0,
            status: course.status
        )
      end
    }
  end

  desc '订单转移'
  task :order => :environment do
    OrderItem.where(sku: nil).map { |item|
      sku = Sku.find_by(course_id: item.course_id)
      if sku.present?
        item.update(price: sku.selling_price, sku: sku.sku)
      end
    }
  end

  desc '订单数量'
  task :orders_count => :environment do
    Sku.all.each { |sku|
      sku.update(orders_count: (OrderItem.joins(:order).where(orders: {status: 2}, sku: 'CC-000088-001147').sum(:amount) + rand(100)))
    }
  end

  desc '课时转移'
  task :lesson => :environment do
    Lesson.where(sku: nil).map { |lesson|
      course = Course.find_by(id: lesson.course_id)
      order = lesson.order
      if course.present?
        lesson.update(sku: Sku.find_by(course_id: course.id).sku, code: (1..lesson.available).map { |index|
                                                                  'L'+('%05d' % lesson.user_id) +('%04d' % order.id) + '%02d' % index
                                                                })
      end
    }
  end

  desc '预约转移'
  task :appointment => :environment do
    Lesson.all.map { |lesson|
      index = 0
      lesson.appointments.where(sku: nil).map { |appointment|
        appointment.update(sku: lesson.sku, code: lesson.code[index])
        index = index + 1
      }
    }
  end


  desc '预约转移'
  task :concerned => :environment do
    Concerned.where(sku: nil).map { |item|
      sku = Sku.find_by(course_id: item.course_id)
      if sku.present?
        item.update(sku: sku.sku)
      else
        item.destroy
      end
    }
  end


  desc ''
  task :comment => :environment do
    Comment.where(sku: nil).each { |item|
      image = CommentImage.where(comment_id: item.id).map { |image| image.image }
      item.update(image: image) if image.present?
    }
  end
end