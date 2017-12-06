# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10_000.times do
  Sighting.create do |s|
    s.species = Species.unscoped.order('RANDOM()').first
    s.user = User.unscoped.order('RANDOM()').first
    s.pictureData = 'picture data'
    s.pictureContentType = 'image/png'
    s.geoLongitude = rand * 360 - 180
    s.geoLatitude = rand * 180 - 90
  end
end