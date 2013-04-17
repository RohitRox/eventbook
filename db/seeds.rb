# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'ffaker'

10.times{ User.create( email: Faker::Internet.email, password: "secretpassword", password_confirmation: "secretpassword") }

PLACES = [
          {"Kamaladi, Kathmandu 44600, Nepal" => [85.31999786931146, 27.71067404836873]},
          {"Tripureshwor, Kathmandu 44600, Nepal" => [85.31491419999998, 27.6949964]},
          {"Kupondole, Patan 44600, Nepal" =>[85.31491419999998, 27.6862181]},
          {"Dillibazar, Dilli Bazaar Rd, Kathmandu 44600, Nepal" => [85.32666919999997, 27.705404]},
          {"New Baneshwor, Kathmandu 44600, Nepal" => [85.3420486, 27.6915196]},
          {"Anamnagar, Kathmandu 44600, Nepal" => [85.32880610000007, 27.6965614]}
          ]

10.times do
  place = PLACES.shuffle.first
  User.all.shuffle.last.events.create(
    title: Faker::Name.name,
    category: Event::CATEGORIES.shuffle.last,
    entrance: Event::ENTRANCE.shuffle.last,
    date: Time.now + rand(10).days,
    address: place.keys.first,
    coordinates: place.values.last
    )

end

8.times{ |i|
  event = Event.all.shuffle.first
  user = User.all[i]
  binding.pry
  booking = user.bookings.new(event: event)
  booking.save!
  2.times { booking.tickets.create(user: user) }
}