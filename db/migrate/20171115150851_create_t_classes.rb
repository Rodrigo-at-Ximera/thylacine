# frozen_string_literal: true
class CreateTClasses < ActiveRecord::Migration[5.1]
  def change
    create_table :t_classes do |t|
      t.string :name, blank: false, null: false
      t.references :phylum, foreign_key: true, null: false

      t.timestamps
    end
  end
end
