class Api::V1::UsersController <  Api::V1::BaseController

    skip_before_filter :verify_authenticity_token
    respond_to :json
        skip_before_filter :authenticate_user!


    def create
      email = params[:email]
      password = params[:password]

      if email.nil? || password.nil?
         render :status=>400,
                :json=>{:message=>"The request must contain the user email and password."}
         return
      end

       if User.where(email: email).first
         render :status=>400,
                :json=>{:message=>"Email already taken"}
         return
       end

      @user=User.create(email: email.downcase)

      if @user
        @user.ensure_authentication_token!
        render :status=>200, :json=>{:token=>@user.authentication_token}
      else
        render :status=>400, :json=>{:message=>"User could not be created"}
      end

    end

end