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

FactoryGirl.define do
  factory :picture do
    name Faker::Name.name
    image File.open(File.join(Rails.root, 'public/index.jpeg'))
    description "MyText"
  end
end
