# frozen_string_literal: true
class CreateCommonNames < ActiveRecord::Migration[5.1]
  def change
    create_table :common_names do |t|
      t.string :name, blank: false, index: true, null: false
      t.references :species, foreign_key: true, null: false
      t.integer :confidence, default: 0, null: false

      t.timestamps
    end
  end
end
