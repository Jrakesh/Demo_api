class Api::V1::PicturesController < Api::V1::BaseController
  load_and_authorize_resource
  before_filter :authenticate_user!
   
  api! "show picture."
  header :token, 'Token to identify user.', required: true
  header :album_id, "Unique id for album.", required: true
  header :id, "Unique id for picture.", required: true
  
  desc "This api show pictures"
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "success": true,
        "album": {
          "name": "second album",
          "description": "this is second album description"
        },
        "pictures": [
          {
            "name": "second album image",
            "description": "this is second image description",
            "image": "/uploads/picture/image/3/index.jpeg"
          }
        ]
      }

    IF STATUS 401:
      Response in Body:
      {
        "success": false,
        "message": "You are not authorized to access"
      }
  '
  def show
    ability = Ability.new(current_user).can? :read, Picture
    if ability
      album = Album.find(params[:album_id])
      picture = album.pictures.find(params[:id])
      if album
        render json: {picture: picture.as_json}, status: 200
      else
        render json: {albums: ["no picture found"]}, status: 404
      end
    else
      render json: {success: false, message: "You are not authorized"}, status: 401
    end
  end

  api! "Create new picture."
  header :token, 'Token to identify user.', required: true
  header :album_id, "Unique id for album.", required: true
  header :id, "Unique id for picture.", required: true
  param :name, String, :required => true
  param :description, String, :required => true
  param :image, String, :required => true
  desc "This api will create new picture."
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "success": true,
        "message": "Picture created successfully.",
        "album": {
          "name": "Test Picture",
          "description": "This is test Picture description",
          "image_file": ""
          "album_name": ""
        }
      }
    
    IF STATUS 422:
      Response in Body:
      {
        "success": false,
        "errors": [
          {
            "field": "name",
            "text": "has already been taken"
          }
        ]
      }
    IF STATUS 401:
      Response in Body:
      {
        "success": false,
        "message": "You are not authorized to access"
      }
  '
  def create
    ability = Ability.new(current_user).can? :create, Picture
    if ability
      album = Album.find(params[:album_id])
      picture = album.pictures.build(picture_params)
      if picture.save
        render json: {success: true, message: "Picture created successfully.", picture: picture.as_json }, status: 200
      else
        render json: {success: false, errors: picture.errors }, status: 422
      end
    else
      render json: {success: false, message: "You are not authorized"}, status: 401
    end
  end

  api! "Update existing picture."
  header :token, 'Token to identify user.', required: true
  header :album_id, "Unique id for album.", required: true
  header :id, "Unique id for picture.", required: true
  param :name, String, :required => true
  param :description, String, :required => true
  param :image, String, :required => true
  desc "This api will update existing Picture."
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "success": true,
        "message": "Picture updated successfully.",
        "album": {
          "name": "Test Picture",
          "name": "This is test Picture1 description"
        }
      }
    
    IF STATUS 422:
      {
        "success": false,
        "errors": [
          {
            "field": "name",
            "text": "has already been taken"
          }
        ]
      }
    IF STATUS 401:
      Response in Body:
      {
        "success": false,
        "message": "You are not authorized to access"
      }
  '
  def update
    ability = Ability.new(current_user).can? :update, Picture
    if ability
      album = Album.find(params[:album_id])
      picture = album.pictures.find(params[:id])
      picture.update_attributes(picture_params)
      if picture.save
        render json: {success: true, message: "Picture update successfully.", picture: picture.as_json }, status: 200
      else
        render json: {success: false, errors: picture.errors }, status: 422
      end
    else
      render json: {success: false, message: "You are not authorized"}, status: 401
    end
  end

  api! "Delete Picture."
  header :token, 'Token to identify user.', required: true
  header :album_id, "Unique id for album.", required: true
  header :id, "Unique id for picture.", required: true
  desc "This api will delete album"
  example 'Response:
    IF STATUS 200:
      Response in Body:
      { 
        "succss": true 
        "message": "Album deleted successfully."
      }
    IF STATUS 401:
      Response in Body:
      {
        "success": false,
        "message": "You are not authorized to access"
      }
  '
  def destroy
    ability = Ability.new(current_user).can? :update, Picture
    if ability
      album = Album.find(params[:album_id])
      picture = album.pictures.find(params[:id])
      picture.delete
      render json: {success: true, message: "Picture update successfully.", picture: picture.as_json }, status: 200
    else
      render json: {success: false, message: "You are not authorized"}, status: 401
    end
  end

  private
    def picture_params
      params.require(:picture).permit(:name, :description, :image, :album_id)
    end

end
