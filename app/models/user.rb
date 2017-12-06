# frozen_string_literal: true
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :set_default_role

  ROLES = %w[spotter taxonomist admin].freeze

  validates :role, inclusion: { in: ROLES }

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role) if role
  end


  private

  def set_default_role
    self.role ||= 'spotter'
  end
end
