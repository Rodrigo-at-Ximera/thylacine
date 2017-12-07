# frozen_string_literal: true

class SightingForm
  include ActiveModel::Model
  include TaxonomyHelper

  attr_accessor(
    :species,
    :species_id,
    :genus,
    :genus_id,
    :family,
    :family_id,
    :order,
    :order_id,
    :t_class,
    :t_class_id,
    :phylum,
    :phylum_id,
    :kingdom,
    :kingdom_id,

    :geoLatitude,
    :geoLongitude
  )
end
