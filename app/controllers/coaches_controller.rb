class CoachesController < ApplicationController
  layout 'admin'

  def index
    @coaches = @service.coaches.paginate(page: params[:page]||1, per_page: 10)
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
      @failure = @coach.errors
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
    params[:coach][:profile_attributes][:address] = (params[:province] + params[:city] + params[:area]).gsub('市辖区', '').gsub('市辖县', '')
    params.require(:coach).permit(:mobile, :password, profile_attributes:
                                             [:avatar, :name, :gender, :birthday, :signature, :address, :target, :skill, :often_stadium, :interests, :identity])
  end
end
