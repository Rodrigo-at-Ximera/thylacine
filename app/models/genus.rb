# frozen_string_literal: true
class Genus < TaxonomyRecord
  belongs_to :family
  has_many :species
  has_many :sightings, through: :species

  validates :family, presence: true

  def parent
    family
  end

  def children
    species
  end
end
