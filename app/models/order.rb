# frozen_string_literal: true

class Order < TaxonomyRecord
  belongs_to :t_class
  has_many :families
  has_many :genus, through: :families
  has_many :species, through: :genus
  has_many :sightings, through: :species

  validates :t_class, presence: true

  def parent
    t_class
  end

  def children
    families
  end
end
