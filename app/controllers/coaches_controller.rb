class CoachesController < ApplicationController
  layout 'admin'

  def index
    @q = Coach.ransack(params[:q])
    @coaches = @q.result.paginate(page: params[:page]||1, per_page: 5).order("updated_at desc")
  end

  def new
    @coach = Coach.new
    @coach.build_profile(birthday: Date.today.prev_year(30))
    @success = params[:success]
    @failure = params[:failure]
  end

  def create
    coach = Coach.new(coach_params)
    coach.client_id = current_user.client_id
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
