namespace :rank do
  desc '计算周like榜'
  task :week => :environment do
    start_date = Time.now.at_beginning_of_week
    end_date = Time.now.tomorrow.at_beginning_of_day
    ranks = Like.where(like_type: Like::PERSON, created_at: start_date..end_date).group(:liked_id).limit(50).order('count_id desc').count(:id)
    Rails.cache.write('week', ranks)
  end

  desc '计算月like榜'
  task :month => :environment do
    start_date = Time.now.at_beginning_of_month
    end_date = Time.now.at_beginning_of_day
    ranks = Like.where(like_type: Like::PERSON, created_at: start_date..end_date).group(:liked_id).limit(50).order('count_id desc').count(:id)
    Rails.cache.write('month', ranks)
  end
end