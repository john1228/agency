class ServicesController < InheritedResources::Base
  layout "admin"
  def index
    puts 3
  end

  def show
    if params[:id].nil?
      render :index
      return
    else
      super
    end
  end
end
