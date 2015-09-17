namespace :image do
  desc '用户注册'
  task :resize => :environment do
    image = Magick::Image.read("#{Rails.root}/app/assets/images/banner.jpg").first
    width, height = image.columns, image.rows
    rate = (width > height) ? (width / 1920.to_f) : (height / 1080.to_f)
    thumb = image.resize(width/rate, height/rate)
    thumb.write("#{Rails.root}/app/assets/images/banner.jpg")
  end
end