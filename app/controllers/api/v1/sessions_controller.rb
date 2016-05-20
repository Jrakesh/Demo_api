class Api::V1::SessionsController < Api::V1::BaseController
  before_action :authenticate_api_user!, only: :destroy
  
  api! "Sign In user"
  param :email, String, required: true
  param :password, String, required: true
  desc "This api will login user on angular side as well as on rails backend side."
  example 'Response:
    IN HEADERS:
      {token: <token>}
      
    IN BODY:
    {
      "success": true,
      "message": "Signed in successfully.",
      "user": {
        "email": "affimintus@gmail.com",
        "name": "affimintus"
      }
    }
  '
  def create
    user = User.find_by_email params["email"]
    return invalid_login_attempt unless user.present?
    if user.valid_password? params["password"]  
      response["token"] = AuthToken.issue_token({user_id: user.id})
      sign_in :user, user
      render json: { success: true, message: "Signed in successfully.",
                    user: user.as_json(only: [:name, :email])
                   }, status: 200
    else
      invalid_login_attempt
    end
  end
  
  api! "Logout user"
  header :token, 'JWT Token to identify user.', required: true
  desc "This api will logout user from rails backend session."
  example 'Response:
    {
      "success": true,
      "message": "Signed out successfully."
    }
  '
  def destroy
    sign_out(current_api_user) if current_api_user.present?
    render json: { success: true, message: "Signed out successfully." }, status: 200
  end

  private
    def invalid_login_attempt
      render json: {
        success: false,
        message: "Email or password is invalid."
      }, status: 401
    end
end