# frozen_string_literal: true
class CreateSpecies < ActiveRecord::Migration[5.1]
  def change
    create_table :species do |t|
      t.string :name, blank: false, index: true, null: false
      t.references :genus, foreign_key: true, null: false

      t.timestamps
    end
  end
end
