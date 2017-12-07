# frozen_string_literal: true

class RemoveSightingPictureColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :sightings, :pictureData, :binary, null: false
    remove_column :sightings, :pictureContentType, :string, null: false
  end
end
