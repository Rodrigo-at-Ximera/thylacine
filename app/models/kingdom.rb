# frozen_string_literal: true
class Kingdom < TaxonomyRecord
  has_many :phylums
  has_many :t_classes, through: :phylums
  has_many :orders, through: :t_classes
  has_many :families, through: :orders
  has_many :genus, through: :families
  has_many :species, through: :genus
  has_many :sightings, through: :species

  def parent
    nil
  end

  def children
    phylums
  end
end
