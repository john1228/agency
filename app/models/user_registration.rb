#encoding: utf-8
class UserRegistration < ActiveRecord::Base
  enum gender: [:male, :female]
  enum source: [:meixing, :input]
  enum reg_type: [:associate_member, :member]

  mount_uploader :avatar, ProfileUploader

  validates :name,:birthday,:gender,:mobile,:service_id,:province,:city,:address,:avatar, presence: true

  validates_uniqueness_of :mobile,scope: :client_id
  belongs_to :service
  #belongs_to :user

  def self.create_from_input(params, client_id)

    transaction do
      object = new(params)
      object.client_id = client_id
      user = User.where(:mobile => params[:mobile]).first
      if user.present?
        object.user_id = user.id
      else
        user = User.new()
        user.mobile = params[:mobile]
        user.sns = SecureRandom.hex
        user.save!
        profile = Profile.new(params.slice(:name,:birthday,:gender,:mobile,:province,:city,:address))
        profile.identity = 0
        profile.save!
        user.profile = profile
        user.save!
        object.user_id = user.id
      end

      #user_registration = UserRegistration.where(:user_id => user.id, :mobile => mobile)
      [object.save,object]
    end
    #what if user_registration.present?
  end

  def reg_type_i18n
    return "准会员"
    if member_cards.count > 0
      "会员"
    else
      "准会员"
    end

  end
end
