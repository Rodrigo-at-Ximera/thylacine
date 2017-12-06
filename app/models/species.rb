# frozen_string_literal: true
class Species < TaxonomyRecord
  belongs_to :genus
  has_many :sightings

  validates :genus, presence: true

  def parent
    genus
  end

  def children
    nil
  end
end
