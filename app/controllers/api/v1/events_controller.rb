class Api::V1::EventsController < Api::V1::BaseController
  respond_to :json

  # layout 'false'

  def index
    page = params[:page] || 1
    @events = params[:category] ? Event.where(category: params[:category]).page(page).desc(:created_at) : Event.page(page).desc(:created_at)
    # render :json => @events.to_json
  end

  def show
    @event = Event.find(params[:id])
  end

  def book
    event = Event.find(params[:id])
    booking = @user.bookings.new(event: event)
    booking.save!
    ticket_arr = []
    params[:t_qty].to_i.times do
      ticket = booking.tickets.create(user: @user)
      ticket_arr << { ticket: ticket.id.to_s }
    end
    #@event = Struct.new(:title,:tickets).new(event.title,ticket_arr)
    render json: {
                    booking_id: booking.id.to_s,
                    event: event.title,
                    t_qty: ticket_arr.size,
                    address: event.address,
                    datetime: "#{event.date} #{event.time}",
                    longt: event.coordinates.first,
                    latt: event.coordinates.last
                  }
  end

  def geocode
    @events = Event.near([params[:latt].to_f,params[:long].to_f],5).all
  end

end