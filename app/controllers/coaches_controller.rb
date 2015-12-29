class CoachesController < InheritedResources::Base
  layout 'admin'

  def index
    @query= Coach.where(:client_id => current_user.client_id).ransack(params[:q])
    @coaches = @query.result.paginate(page: params[:page]||1, per_page: 5).order("updated_at desc")
  end

  def new
    @coach = Coach.new
    @coach.build_profile(birthday: Date.today.prev_year(30))
    @success = params[:success]
    @failure = params[:failure]
  end

  def show
    @coach = Coach.find(params[:id])
    @default_discount = @coach.default_discount
    @default_discount = @coach.build_default_discount(discount: 80, giveaway_cash: 50, giveaway_count: 5, giveaway_day: 20) if @default_discount.nil?
    @discounts = @coach.discounts.includes(:card).paginate(page: params[:page]||1, per_page: 5).order('id desc')
  end

  def create
    coach = Coach.new(coach_params)
    coach.client_id = current_user.client_id
    coach.profile.identity = 1
    if coach.save
      ServiceMember.create(service_id: coach.service_id, coach: coach)
      @success = true
      flash[:success] = "成功创建私教"
      redirect_to coaches_path
      return
    else
      @failure = coach.errors
      @coach = coach
    end
    render action: :new
  end

  def destroy
    # @coach

    render json: {result: true}
  end

  private
  def coach_params
    params[:coach][:profile_attributes][:province] = params[:province]
    params[:coach][:profile_attributes][:city] = params[:city]
    params.require(:coach).permit(:mobile, :password, :service_id, profile_attributes:
                                             [:avatar, :name, :mobile, :gender, :birthday, :signature, :province, :city, :identity, hobby: []])
  end
end
