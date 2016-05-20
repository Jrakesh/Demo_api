class Api::V1::RegistrationsController < Api::V1::BaseController
  skip_before_filter :verify_authenticity_token,:authenticate_user!, :only => :create
  
  respond_to :json

  api! "Create new user."
  param :name, String, :required => true
  param :email, String, :required => true
  param :password, String, :required => true
  param :password_confirmation, String, :required => true 
  desc "This api will create new user."
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "success": true,
        "message": "Signed up successfully.",
        "user": {
          "email": "affimintus@gmail.com",
          "name": "affimintus"
        }
      }
    
    IF STATUS 422:
      {
        "success": false,
        "errors": [
          {
            "field": "email",
            "text": "has already been taken"
          }
        ]
      }
  '
  def create
    user_details = {
      "name" => params["name"], 
      "email" => params["email"],
      "password" => params["password"],
      "password_confirmation" => params["password_confirmation"]
    }

    user = User.new user_details
    if user.save
      message = "Signed up successfully."
      access_token = AuthToken.issue_token({user_id: user.id})
      render json: { success: true, message: message, access_token: access_token, user: user.as_json(only: [:name, :email]) }, status: 201
    else
      render json: { success: false, errors: user.errors.messages.map{|e| e[1].map{|m| {field: e[0], text: "#{e[0].capitalize} #{m}"}}.compact}.flatten }, status: 422
    end
  end
end