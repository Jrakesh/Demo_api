class AlbumsController < ApplicationController
  load_and_authorize_resource
  
  def index
    @albums = Album.all
  end

  def show
    @album = Album.find(params[:id])
    @album_pictures = @album.pictures 
  end

  def new
    @album = current_user.albums.build
  end

  def create
    @album = current_user.albums.build(album_params)
    if @album.save
      redirect_to albums_path
    else
      redirect_to new_album_path
    end
  end

  def edit
    @album = Album.find(params[:id])
  end 

  def update 
    @album = Album.find(params[:id])
    @album.update_attributes(album_params)
    redirect_to albums_path
  end

  def destroy
    @album = Album.find(params[:id])
    @student.delete
    redirect_to albums_path
  end

  private
    def album_params
      params.require(:album).permit(:name, :description, :user_id)
    end

end
  