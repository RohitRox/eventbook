class EventsController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:index, :show]
  load_and_authorize_resource

  def index
    page = params[:page] || 1
    @events = params[:category] ? Event.where(category: params[:category]).page(page).desc(:created_at) : Event.page(page).desc(:created_at)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  def my_events
    page = params[:page] || 1
    @events = current_user.events.page(page).desc(:created_at)
  end

  def show
    @event = Event.find(params[:id])
    @bookings = @event.bookings.size

    e_group = @event.bookings.asc(:created_at).group_by { |event| event.created_at.to_i*1000 }
    #e_group.each { |k, v| e_group[k] = v.size }
    @data_arr = e_group.update(e_group){|key,v1| v1.size}.to_a

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
    redirect_to events_path and return unless user_signed_in?
    @event = Event.find(params[:id])
    redirect_to events_path and return unless can? :manage, @event
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
        Publisher.new(@event).publish
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    redirect_to events_path and return unless user_signed_in?
    @event = Event.find(params[:id])
    redirect_to events_path and return unless can? :manage, @event
    param = params[:event].tap { |e|
      e['date'] = Date::civil(e['date(1i)'].to_i, e['date(2i)'].to_i, e['date(3i)'].to_i)
      e.delete("date(1i)")
      e.delete("date(2i)")
      e.delete("date(3i)")
      e[:coordinates].map!(&:to_f)
    }
    respond_to do |format|
      if @event.update_attributes(param)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    redirect_to events_path and return unless user_signed_in?
    @event = Event.find(params[:id])
    redirect_to events_path and return unless can? :manage, @event
    @event.destroy
    respond_to do |format|
      format.html { redirect_to my_events_url, notice: 'Event was successfully deleted.' }
      format.json { head :no_content }
    end
  end
end
