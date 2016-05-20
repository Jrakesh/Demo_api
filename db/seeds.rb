# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# user = CreateAdminService.new.call
# puts 'CREATED ADMIN USER: ' << user.email


 
user1 = User.create!(email: "admin_user@gmail.com", name: "admin_user", password: "12345679")
user1.add_role :admin

user2 = User.create!(email: "normal_user@gmail.com", name: "simple_user", password: "12345679")
user2.add_role :user

user1 = User.create!(email: "guest_user@gmail.com", name: "guest_user", password: "12345679")
user1.add_role :guest

album = user1.albums.create!(name: "first_album", description: "first album description")

album.pictures.create!(name: 'first album image', description: "description for first album picture", image: File.open(File.join(Rails.root, 'public/index.jpeg')))
