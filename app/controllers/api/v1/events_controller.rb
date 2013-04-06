class Api::V1::EventsController < Api::V1::BaseController

  def index
    @events = Event.all
    respond_to do |format|
      format.json { render json: @events }
    end
  end

  def show

  end

  def book
  end

end