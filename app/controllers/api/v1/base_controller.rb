class Api::V1::BaseController < ApplicationController

  # before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers
  skip_before_filter :verify_authenticity_token
  before_filter :find_by_auth_token

  protected

  def find_by_auth_token
    return nil unless params[:auth_token]
    @user = User.where(authentication_token: params[:auth_token]).first
  end

  # For all responses in this controller, return the CORS access control headers.

  def cors_preflight_check
    if request.method == :options
      headers['Access-Control-Allow-Origin'] = '*'
     headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
     headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
     headers['Access-Control-Max-Age'] = '1728000'
     render :text => '', :content_type => 'text/plain'
   end
 end

 def cors_set_access_control_headers
   headers['Access-Control-Allow-Origin'] = '*'
   headers['Access-Control-Request-Method'] = '*'
 end

end