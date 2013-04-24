class SurveysController < ApplicationController

  # skip_before_filter :authenticate_user!, only: [:index, :show]
  # load_and_authorize_resource

  def new
    @questions = []
    @event = Event.find(params[:event_id])
    @survey = @event.build_survey
    3.times { @questions << @survey.questions.build }
  end


  def show
    @event = Event.find(params[:event_id])
    @survey = @event.survey
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  def create
    @event = Event.find(params[:event_id])
    @survey = @event.create_survey(params[:survey])
    respond_to do |format|
      if @survey
        format.html { redirect_to @event, notice: 'A survey was successfully created.' }
        format.json { render json: @survey, status: :created, location: @survey }
      else
        format.html { render action: "new" }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end

  def answer
    @event = Event.find(params[:event_id])
    @survey = @event.survey
    @questions = @event.survey.questions
    # @answers = @questions.map{|q| q.answers.build}
  end

  def update
    @event = Event.find(params[:event_id])
    @survey = @event.survey
    @survey.update_attributes(params[:survey])
    redirect_to @event
  end

  def respond_with_mood
    @event = Event.find(params[:event_id])
    @survey = @event.survey
    if @survey.questions.present? && @survey.questions.map(&:answer).present?
    render json: @survey.moody
  else
    render json: {}
  end
  end
end
