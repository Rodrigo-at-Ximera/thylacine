# frozen_string_literal: true
class CreateKingdoms < ActiveRecord::Migration[5.1]
  def change
    create_table :kingdoms do |t|
      t.string :name, blank: false, null: false

      t.timestamps
    end
  end
end
