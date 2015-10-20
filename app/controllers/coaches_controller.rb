class CoachesController < ApplicationController
  layout 'admin'

  def index
    @coaches = @service.coaches.paginate(page: params[:page]||1, per_page: 10)
  end

  def new
    @coach = Coach.new
    @coach.build_profile
    @success = params[:success]
    @failure = params[:failure]
  end

  def create
    coach = Coach.new(coach_params)
    if coach.save
      ServiceMember.create(service: @service, coach: coach)
      @success = true
      @coach = Coach.new
      @coach.build_profile
    else
      @failure = coach.errors
      @coach = coach
    end
    render action: :new
  end

  def update

  end

  def destroy
    # @coach

    render json: {result: true}
  end

  private
  def coach_params
    params[:coach][:profile_attributes][:province] = params[:province]
    params[:coach][:profile_attributes][:city] = params[:city]
    params.require(:coach).permit(:mobile, :password, profile_attributes:
                                             [:avatar, :name, :gender, :birthday, :signature, :province, :city, :identity, hobby: []])
  end
end
