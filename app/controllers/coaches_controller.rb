class CoachesController < ApplicationController
  layout 'login'

  def index
    @coaches = @service.coaches.paginate(page: params[:page]||1, per_page: 1)
  end

  def new
    @coach = Coach.new
  end

  def show
  end

  def create
    @coach = Coach.new(coach_params)
    # if @coach.save
    #   @success = true
    # else
    #   @failure = true
    # end
    render action: :show
  end

  def update

  end

  def destroy

  end

  private
  def coach_params
    params.require(:coach).permit(:mobile, :password).merge(profile_attributes: params.require(:coach).require(:profile).permit(:avatar, :name, :gender, :birthday, :signature, :address, :target, :skill, :often_stadium, :interests))
  end
end
