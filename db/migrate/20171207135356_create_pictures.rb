# frozen_string_literal: true

class CreatePictures < ActiveRecord::Migration[5.1]
  def change
    create_table :pictures do |t|
      t.binary :data, null: false
      t.string :content_type, null: false, blank: false
      t.references :sighting, index: { unique: true }, foreign_key: true

      t.timestamps
    end
  end
end
