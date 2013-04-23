class Api::V1::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_filter :find_by_auth_token
  after_filter :cors_set_access_control_headers

  protected

  def find_by_auth_token
    return nil unless params[:auth_token]
    @user = User.where(authentication_token: params[:auth_token]).first
  end

  def cors_set_access_control_headers
   headers['Access-Control-Allow-Origin'] = '*'
   headers['Access-Control-Request-Methods'] = 'POST, GET, OPTIONS'
  end

end