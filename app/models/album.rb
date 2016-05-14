class Album < ActiveRecord::Base
  resourcify
  
  has_many :pictures
  belongs_to :user
end
