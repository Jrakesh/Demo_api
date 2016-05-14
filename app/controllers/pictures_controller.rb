class PicturesController < ApplicationController
  load_and_authorize_resource
   
  def index
    redirect_to root_path  
  end

  def show
    @album = Album.find(params[:album_id])
    @picture = @album.pictures.find(params[:id])
  end

  def new
    @album = Album.find(params[:album_id])
    @picture = @album.pictures.build
  end

  def create
    @album = Album.find(params[:album_id])
    @picture = @album.pictures.build(picture_params)
    if @picture.save
      redirect_to album_path(@album)
    else
      redirect_to new_album_picture_path
    end
  end

  def edit
    @album = Album.find(params[:album_id])
    @picture = @album.pictures.find(params[:id])
  end 

  def update
    @album = Album.find(params[:album_id])
    @picture = @album.pictures.find(params[:id])
    @picture.update_attributes(picture_params)
    redirect_to album_path(@album)
  end

  def destroy
    @album = Album.find(params[:album_id])
    @picture = @album.pictures.find(params[:id])
    @picture.delete
    redirect_to album_path(@album)
  end

  private
    def picture_params
      params.require(:picture).permit(:name, :description, :image, :album_id)
    end

end
