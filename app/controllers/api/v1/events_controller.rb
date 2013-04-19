class Api::V1::EventsController < Api::V1::BaseController
  respond_to :json

  # layout 'false'

  def index
    @events = Event.all
    # render :json => @events.to_json
  end

  def show
    @event = Event.find(params[:id])
    render :json => @event.to_json
  end

  def book
    event = Event.find(params[:id])
    booking = @user.bookings.new(event: event)
    booking.save!
    ticket_arr = []
    params[:qty].times do
      ticket = booking.tickets.create(user: @user)
      ticket_arr << { ticket: ticket.id.to_s }
    end
    render json: {
                    event: event.title,
                    tickets: ticket_arr
                  }
  end

end