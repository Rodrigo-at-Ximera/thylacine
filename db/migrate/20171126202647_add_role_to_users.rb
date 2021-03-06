# frozen_string_literal: true
class AddRoleToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :role, :string, blank: false, null: false, default: 'spotter'
  end
end
