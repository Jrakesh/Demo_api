class Picture < ActiveRecord::Base
  resourcify
  
  mount_uploader :image, ImageUploader
  belongs_to :album
end
