class VideoProcessJob < ActiveJob::Base
  queue_as :default

  def perform(file_path, store_path, file_extension)
    file_name = file_path.gsub("#{Rails.root}/public/videos/", '')

    transcode_path = "#{file_path.gsub(".#{file_extension}", '')}_1.mp4"
    transcode_command = "ffmpeg -i #{file_path}  -vcodec libx264 -maxrate 500k -bufsize 1000k -vf scale=640:-2 -threads 0 -f mp4 #{transcode_path}"
    system(transcode_command)

    hls_name = "#{Rails.root}/public/videos/hls/#{file_name.gsub(store_path, "").gsub(file_extension, 'm3u8')}"
    FileUtils.mkdir_p File.dirname(hls_name) unless File.exists?(hls_name)
    split_command = "ffmpeg -v 9 -re -i #{transcode_path} -acodec libmp3lame -c:v libx264 -flags -global_header -map 0 -f segment -segment_time 10 -segment_list #{hls_name} -segment_format mpegts #{hls_name}%04d.ts"
    system(split_command)
  end
end
