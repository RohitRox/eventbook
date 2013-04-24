require 'ostruct'

class Api::V1::HomeController <  Api::V1::BaseController

  skip_before_filter :authenticate_user!, only: [:index]
  respond_to :json

  def index
    @r_hash = OpenStruct.new({message: "We could could find you. Please login."}) unless @user
    near_by_count = params[:latt].present? ? Event.near([params[:latt],params[:longt]], 1).size : 0
    @r_hash = OpenStruct.new({
      upcoming_count: Event.upcoming.size,
      near_by_count: near_by_count,
      featured_count: Event.featured.size,
      interest_in_count: Event.where(:category.in => params[:likes]).size
      })
  end

  def get_events
    param = params[:filter].to_s
    page = params[:page] || 1
    @events = Event.all
    case param
      when "upcoming"
        @events = @events.upcoming.page(page).desc(:created_at)
      when "near_by"
        @events = @events.near([params[:latt],params[:longt]], 1).page(page).desc(:created_at)
      when "featured"
        @events = @events.featured.page(page).desc(:created_at)
      when "interest"
        @events = @events.where(:category.in => @user.likes).page(page).desc(:created_at)
      else
        @events = @events.page(page).desc(:created_at)
    end
  end

end