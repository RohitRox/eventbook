class Api::V1::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_filter :find_by_auth_token

  protected

  def find_by_auth_token
    return nil unless params[:auth_token]
    @user = User.where(authentication_token: params[:auth_token]).first
  end

end