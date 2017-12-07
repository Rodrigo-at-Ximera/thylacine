# frozen_string_literal: true

class MoveSightingPictureToPicture < ActiveRecord::Migration[5.1]
  def change
    Sighting.find_each do |sighting|
      Picture.create do |picture|
        picture.data = sighting.pictureData
        picture.content_type = sighting.pictureContentType
        picture.sighting = sighting
      end
    end
  end
end
