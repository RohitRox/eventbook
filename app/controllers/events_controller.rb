class EventsController < ApplicationController

  def index
    @events = current_user.events.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  def show
    @event = Event.find(params[:id])
    @attendies = @event.bookings.size
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end


  def edit
    @event = Event.find(params[:id])
  end

  def create
    param = params[:event].tap { |e|
      e['date'] = Date::civil(e['date(1i)'].to_i, e['date(2i)'].to_i, e['date(3i)'].to_i)
      e.delete("date(1i)")
      e.delete("date(2i)")
      e.delete("date(3i)")
      e[:coordinates].map!(&:to_f)
    }
    @event = current_user.events.new(param)
    respond_to do |format|
      if @event.save
        @event.update_attribute(:address, @event.reverse_geocode) unless @event.address.present?
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end
end
