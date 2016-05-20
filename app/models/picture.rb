# == Schema Information
#
# Table name: pictures
#
#  id          :integer          not null, primary key
#  name        :string
#  image       :string
#  description :text
#  album_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Picture < ActiveRecord::Base
  resourcify
  
  mount_uploader :image, ImageUploader

  belongs_to :album

  belongs_to :user
  
  validates :description, :image, presence: true

  #validates :name, uniqueness: true
  
  def as_json(options={})
    super(:only => [:name,  :description],
          :methods => [ :image_file, :album_name])
  end

  def image_file
  	image.try(:url)
  end

  def album_name
  	album.try(:name)
  end
end
