class Api::V1::AlbumsController < Api::V1::BaseController
  #load_and_authorize_resource
  
  api! "Get list of all album."
  header :token, 'Token to identify user.', required: true
  desc "This api will get list of album."
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "success": true,
        "albums": [
          {
            "name": "second album",
            "description": "this is second album description"
          },
          {
            "name": "My selfi album",
            "description": "this is my first album and am containing my all selfi here.."
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


  def index
    ability = Ability.new(current_user).can? :read, Album
    if ability
      albums = Album.all
      unless albums.blank?
        render json: {success: true, albums: albums.map(&:as_json)}, status: 200
      else
        render json: {success: true, message: ["no album found"]}, status: 200
      end
    else
      render json: {success: false, message: "You are not authorized"}, status: 401
    end
  end

  api! "show album."
  header :token, 'Token to identify user.', required: true
  header :id, "Unique id for album.", required: true
  desc "This api show album with pictures"
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
    ability = Ability.new(current_user).can? :read, Album
    if ability
      album = Album.find(params[:id])
      if album
        render json: {success: true, album: album.as_json, pictures: album.album_pictures_as_json}, status: 200
      else
        render json: {success: true, message: ["no album found"]}, status: 404
      end
    else
      render json: {success: false, message: "You are not authorized"}, status: 401
    end
    
  end

  api! "Create new album."
  header :token, 'Token to identify user.', required: true
  param :name, String, :required => true
  param :description, String, :required => true
  desc "This api will create new Album."
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "success": true,
        "message": "Album created successfully.",
        "album": {
          "name": "Test album",
          "name": "This is test album description"
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
    ability = Ability.new(current_user).can? :create, Album
    if ability
      album = current_user.albums.build(album_params)
      if album.save
        render json: {success: true, message: "Album created successfully.", album: album.as_json }, status: 200
      else
        render json: {success: false, errors: album.errors }, status: 422
      end
    else
      render json: {success: false, message: "You are not authorized"}, status: 401
    end
  end

  
  api! "Update existing album."
  header :token, 'Token to identify user.', required: true
  header :id, "Unique id for album.", required: true
  param :name, String, :required => true
  param :description, String, :required => true
  desc "This api will update existing Album."
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "success": true,
        "message": "Album updated successfully.",
        "album": {
          "name": "Test album1",
          "name": "This is test album1 description"
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
    ability = Ability.new(current_user).can? :update, Album
    if ability
      album = Album.find(params[:id])
      if album.update_attributes(album_params)
        render json: {success: true, message: "Album updated successfully.", album: album.as_json }, status: 200
      else
        render json: {success: false, errors: album.errors}, status: 422
      end
    else
      render json: {success: false, message: "You are not authorized"}, status: 401
    end
  end

  api! "Delete Album."
  header :token, 'Token to identify user.', required: true
  header :id, "Unique id for album.", required: true
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
    ability = Ability.new(current_user).can? :delete, Album
    if ability
      album = Album.find(params[:id])
      if album.delete
        render json: {success: true, message: "Album deleted successfully."}, status: 200
      else
        render json: {success: false, message: "Album not found with id"}, status: 422
      end
    else
      render json: {success: false, message: "You are not authorized"}, status: 401
    end
  end

  private
    def album_params
      params.require(:album).permit(:name, :description, :user_id)
    end

end