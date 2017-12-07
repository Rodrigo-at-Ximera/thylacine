# frozen_string_literal: true

class CreateSightings < ActiveRecord::Migration[5.1]
  def change
    create_table :sightings do |t|
      t.references :species, foreign_key: true, null: false
      t.decimal :geoLatitude, null: false
      t.decimal :geoLongitude, null: false
      t.binary :pictureData, null: false
      t.string :pictureContentType, null: false, blank: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
