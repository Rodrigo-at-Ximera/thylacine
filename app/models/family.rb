# frozen_string_literal: true
class Family < TaxonomyRecord
  belongs_to :order
  has_many :genus, class_name: 'Genus'
  has_many :species, through: :genus
  has_many :sightings, through: :species

  validates :order, presence: true

  def parent
    order
  end

  def children
    genus
  end
end
