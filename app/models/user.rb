# frozen_string_literal: true
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2 facebook linkedin]

  before_validation :set_default_role

  ROLES = %w[spotter taxonomist admin].freeze

  validates :role, inclusion: { in: ROLES }

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role) if role
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.skip_confirmation!
    end
  end


  private

  def set_default_role
    self.role ||= 'spotter'
  end
end
