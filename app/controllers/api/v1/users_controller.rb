class Api::V1::UsersController <  Api::V1::BaseController

  skip_before_filter :authenticate_user!, only: [:create]
  skip_before_filter :find_by_auth_token, only: [:create]

  respond_to :json

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

end