# frozen_string_literal: true
class Phylum < TaxonomyRecord
  belongs_to :kingdom
  has_many :t_classes
  has_many :orders, through: :t_classes
  has_many :families, through: :orders
  has_many :genus, through: :families
  has_many :species, through: :genus
  has_many :sightings, through: :species

  validates :kingdom, presence: true

  def parent
    kingdom
  end

  def children
    t_classes
  end
end
