class CoachesController < ApplicationController
  layout 'login'

  def index
    @coaches = @service.coaches.paginate(page: params[:page]||1, per_page: 1)
  end

  def new
    @coach = Coach.new
    @coach.build_profile
  end

  def create
    @coach = Coach.new(coach_params)
    if @coach.save
      ServiceMember.create(service: @service, coach: @coach)
      @success = true
    else
      @failure = true
    end
    render action: :show
  end

  def update

  end

  def destroy
    render action: :index
  end

  private
  def coach_params
    params.require(:coach).permit(:mobile, :password, profile_attributes:
                                             [:avatar, :name, :gender, :birthday, :signature, :address, :target, :skill, :often_stadium, :interests, :identity])
  end
end
