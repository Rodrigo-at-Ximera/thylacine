# frozen_string_literal: true
class CreateFamilies < ActiveRecord::Migration[5.1]
  def change
    create_table :families do |t|
      t.string :name, blank: false, null: false
      t.references :order, foreign_key: true, null: false

      t.timestamps
    end
  end
end
