class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!

  api! "Get list of all users."
  header :token, 'Token to identify user.', required: true
  desc "This api will get list of users."
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "success": true,
        "users": [
          {
            "name": "test",
            "user_name": "test",
            "email": "test@test.com" 
          }
        ]
      }

  '
  def index
    users = User.all
    unless users.blank?
      render json: {success: true, users: users.map(&:as_json)}, status: 200
    else
      render json: {success: true, message: ["No user found"]}, status: 200
    end
  end

  api! "show user."
  header :token, 'Token to identify user.', required: true
  header :id, "Unique id for user.", required: true
  desc "This api show user"
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "success": true,
        "user": {
          "name": "test",
          "email": "test@test.com",
          "user_name": "test123"
        }
      }

    IF STATUS 401:
      Response in Body:
      {
        "success": false,
        "message": "You are not authorized to access"
      }
  '
  def show
    user = User.find(params[:id])
    unless user == current_user
      render json: {success: false, message: "Access denied."}, status: 401
      render json: "Access denied."
    else
      render json: {success: true, user: user.as_json}, status: 200
    end
  end


  api! "Update existing user."
  header :token, 'JWT Token to identify user.', required: true
  header :id, "Unique id for user.", required: true
  param :name, String
  param :email, String
  desc "This api will update existing user."
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "success": true,
        "message": "user updated successfully.",
      }
    
    IF STATUS 401:
      Response in Body:
      {
        "success": false,
        "message": "You are not authorized to access"
      }
  '
  
  def update
    ability = Ability.new(current_user).can? :read, Album
    if ability
      user = User.find(params[:id])
      if user.update_attributes(params.permit(:email, :name))
        render json: {success: true, message: "user updated successfully"}, status: 200
      else
        render json: {success: false, errors: user.errors }, status: 404
      end
    else
      render json: {success: false, message: "You are not authorized"}, status: 401
    end
  end

  api! "delete existing user."
  header :token, 'JWT Token to identify user.', required: true
  header :id, "Unique id for user.", required: true
  desc "This api will delete user."
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "success": true,
        "message": "user deleted successfully.",
      }
    
    IF STATUS 401:
      Response in Body:
      {
        "success": false,
        "message": "You are not authorized to access"
      }
  '
  def destroy
    ability = Ability.new(current_user).can? :read, Album
    if ability
      user = User.find(params[:id])
      user.destroy
      render json: {success: true, message: "user deleted successfully"}, status: 200
    else
      render json: {success: false, message: "You are not authorized"}, status: 401
    end
  end
end
