# frozen_string_literal: true
class TClass < TaxonomyRecord
  belongs_to :phylum
  has_many :orders
  has_many :families, through: :orders
  has_many :genus, through: :families
  has_many :species, through: :genus
  has_many :sightings, through: :species

  validates :phylum, presence: true

  def parent
    phylum
  end

  def children
    orders
  end
end
