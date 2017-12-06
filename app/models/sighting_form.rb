# frozen_string_literal: true

class SightingForm
  include ActiveModel::Model
  include TaxonomyHelper

  attr_accessor(
    :picture,

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

  def save_sighting(user)
    sighting = Sighting.new
    sighting.species = get_or_initialize_species
    sighting.geoLatitude = geoLatitude
    sighting.geoLongitude = geoLongitude
    sighting.pictureContentType = picture&.content_type
    sighting.pictureData = picture&.tempfile&.read
    sighting.user = user

    if sighting.save
      true
    else
      self.errors = sighting.errors
      false
    end
  end

  def get_or_initialize_species
    need_init = []
    object = nil
    TAXONOMY_MODELS.reverse_each do |model|
      object = model.find_by id: send("#{model.model_name.param_key}_id")
      break if object
      need_init.unshift(model)
    end

    need_init.each do |model|
      object = model.new do |new_object|
        new_object.name = send(model.model_name.element)
        new_object.send("#{object.class.model_name.param_key}=", object) if object
      end
      if cannot? :create, model
        object.errors[:base] << (I18n.t :taxonomy_manage_auth_fail,
                                        model: model.model_name.human.pluralize(locale.to_sym))
      end
    end

    raise if object.class != Species
    object
  end
end
