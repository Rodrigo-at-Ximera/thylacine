# frozen_string_literal: true
class CreateGenus < ActiveRecord::Migration[5.1]
  def change
    create_table :genus do |t|
      t.string :name, blank: false, null: false
      t.references :family, foreign_key: true, null: false

      t.timestamps
    end
  end
end
