# frozen_string_literal: true
class CreatePhylums < ActiveRecord::Migration[5.1]
  def change
    create_table :phylums do |t|
      t.string :name, blank: false, null: false
      t.references :kingdom, foreign_key: true, null: false

      t.timestamps
    end
  end
end
