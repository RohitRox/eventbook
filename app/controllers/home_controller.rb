class HomeController < ApplicationController

  skip_before_filter :authenticate_user!

  def index
    redirect_to events_path and return if current_user
  end

end