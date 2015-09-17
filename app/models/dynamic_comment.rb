class DynamicComment < ActiveRecord::Base
  default_scope { where('1=1').order(id: :desc) }
  belongs_to :dynamic
  belongs_to :user

  def as_json
    {
        content: HarmoniousDictionary.clean(content),
        created: created_at.to_i,
        user: user.summary_json
    }
  end

  def show_time_string
    seconds = Time.now - created_at
    if seconds <60
      '刚刚'
    elsif seconds< 60*60
      "#{(seconds/60).to_i}分钟"
    elsif seconds< 60*60*24
      "#{(seconds/(60*60)).to_i}小时前"
    elsif seconds < 60*60*24*7
      "#{(seconds/(60*60*24)).to_i}天前"
    elsif seconds< 60*60*24*30
      "#{(seconds/(60*60*24*7)).to_i}周前"
    elsif seconds < 60*60*24*365
      "#{(seconds/(60*60*24*30)).to_i}月前"
    else
      "#{(seconds/(60*60*24*365)).to_i}年前"
    end
  end
end
