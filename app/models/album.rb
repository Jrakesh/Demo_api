# == Schema Information
#
# Table name: albums
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Album < ActiveRecord::Base
  resourcify
  
  belongs_to :user
  
  has_many :pictures, dependent: :destroy

  validates :name, :description, presence: true

  validates :name, uniqueness: true

  def as_json(options={})
    super(:only => [:name,  :description],
          :methods => [ :create_by])
  end

  def created_by
  	user.try(:name)
  end

  def album_pictures_as_json
  	pictures.blank? ? ["No pictures available"] : pictures.map{|e| {:name => e.name, :description => e.description, :image => e.image.url}}
  end
end



