# frozen_string_literal: true
class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :name, blank: false, null: false
      t.references :t_class, foreign_key: true, null: false

      t.timestamps
    end
  end
end
