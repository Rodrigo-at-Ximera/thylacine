# frozen_string_literal: true

class Sighting < ApplicationRecord
  belongs_to :species
  belongs_to :user
  has_one_attached :picture

  validates :user, :species, :picture, presence: true
  validates :geoLongitude, numericality: { greater_than_or_equal_to: -180,
                                           less_than_or_equal_to: 180 }
  validates :geoLatitude, numericality: { greater_than_or_equal_to: -90,
                                          less_than_or_equal_to: 90 }


  scope :with_taxonomy, lambda {
    includes(species: [{ genus: [{ family: [{ order: [{ t_class: [{ phylum: [:kingdom] }] }] }] }] }])
      .joins(species: [{ genus: [{ family: [{ order: [{ t_class: [{ phylum: [:kingdom] }] }] }] }] }])
  }

end
