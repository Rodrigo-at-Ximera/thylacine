# frozen_string_literal: true

class Picture < ApplicationRecord
  belongs_to :sighting, optional: true

  validates :data, :content_type, presence: true
  validates :sighting, uniqueness: true, allow_nil: true
end
