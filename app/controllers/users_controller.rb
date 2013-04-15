class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def edit_profile
    @profile = current_user.profile
  end

  def update_profile
    current_user.profile.update_attributes(params[:profile])
    redirect_to user_path(current_user)
  end

end
