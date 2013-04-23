require 'ostruct'
class Api::V1::UsersController <  Api::V1::BaseController

  skip_before_filter :authenticate_user!, only: [:create, :login, :options]
  skip_before_filter :find_by_auth_token, only: [:create, :login, :options]

  respond_to :json

  def options
    headers['Access-Control-Allow-Origin'] = request.env['HTTP_ORIGIN']
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = '1000'
    headers['Access-Control-Allow-Headers'] = '*,x-requested-with'
  end

  def create
    email = params[:email]
    password = params[:password]

    if email.nil? || password.nil?
       render :status=>200,
              :json=>{:message=>"The request must contain the user email and password."}
       return
    end

    user = User.where(email: email).first

    if user
      render :status=>200,
            :json=>{token: user.authentication_token }
      return
    end

    @user=User.create(email: email.downcase, password: password, password_confirmation: password)
    if @user
      @user.ensure_authentication_token!
      render :status=>200, :json=>{:token=>@user.authentication_token}
    else
      render :status=>200, :json=>{:message=>"User could not be created"}
    end

  end

  def tickets

  end

  def bookings

  end

  def show
  end

  def login
    email = params[:email]
    password = params[:password]
    if email.nil? || password.nil?
       @r_hash = OpenStruct.new({:message=>"The request must contain the user email and password."})
    end
    user = User.where(email: email ).first
    if user && user.valid_password?(password)
      user.ensure_authentication_token! unless user.authentication_token
      @r_hash = OpenStruct.new({message: "welcome", token: user.authentication_token })
    else
      @r_hash = OpenStruct.new({:message=>"Invalid Email or password."})
    end
  end

end