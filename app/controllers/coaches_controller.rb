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
    redirect_to action: :new
  end

  def update

  end

  def destroy
    render action: :index
  end

  private
  def coach_params
    params[:coach][:profile_attributes][:province] = params[:province]
    params[:coach][:profile_attributes][:city] = params[:city]
    params.require(:coach).permit(:mobile, :password, profile_attributes:
                                             [:avatar, :name, :gender, :birthday, :signature, :province, :city, :hobby, :identity])
  end
end
