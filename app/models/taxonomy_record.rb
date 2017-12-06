# frozen_string_literal: true

class TaxonomyRecord < ApplicationRecord
  self.abstract_class = true

  validates :name, presence: true

  default_scope { order(:name) }

  def parent
    raise NotImplementedError
  end

  def children
    raise NotImplementedError
  end

  def full_classification
    res = [name]
    res += parent.full_classification if parent
    res
  end
end
