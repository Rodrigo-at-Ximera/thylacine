# frozen_string_literal:true

class TaxonomyController < ApplicationController
  include TaxonomyHelper

  def autocomplete
    result_hash = {}
    model = parse_model(params[:category])
    authorize! :read, model

    model.where('name ~* ?', "\\m#{params[:term]}").each do |s|
      result_hash[s.name] = s.id
    end

    if result_hash.empty? || params[:force_external]
      result_hash = gbif_suggest(params[:term], params[:category], result_hash)
    end

    render json: result_hash.collect { |k, v| { id: v, label: k } }
  end

  def ancestors
    model = parse_model(params[:category])
    object = model.find(params[:id])
    authorize! :read, object
    result = []
    while object.parent
      object = object.parent
      authorize! :read, object
      result << { category: object.class.model_name.param_key,
                  label: object.name,
                  id: object.id }
    end
    render json: result
  rescue TaxonomyCategoryError => e
    authorize! :index, Sighting
    response.status = 404
    render plain: e.message
  end

  def children
    if params[:category] == 'life'
      authorize! :read, Kingdom
      collection = Kingdom.all
    else
      model = parse_model(params[:category])
      object = model.find(params[:id])
      authorize! :read, object
      collection = object.children
    end
    render json: (collection.collect do |child|
      { id: child.id,
        name: child.name,
        category: child.class.model_name.param_key,
        has_children: !child.children.nil? }
    end)
  rescue TaxonomyCategoryError => e
    authorize! :index, Sighting
    response.status = 404
    render plain: e.message
  end

  def sightings
    authorize! :index, Sighting
    model = parse_model(params[:category])
    object = model.find(params[:id])
    sightings = object.sightings
    results = []
    sightings.with_attached_picture.find_each do |sighting|
      if sighting.picture.attached?
        results << { id: sighting.id, lat: sighting.geoLatitude, lng: sighting.geoLongitude }
      end
    end
    render json: results
  end


  private

  GBIF_BASE_URL = 'http://api.gbif.org/v1/species'
  private_constant :GBIF_BASE_URL

  def gbif_suggest(term, category, result_hash)
    gbif_response = RestClient.get "#{GBIF_BASE_URL}/suggest",
                                   params: { q: term, rank: category }
    if gbif_response.code == 200
      JSON.parse(gbif_response.body).reject { |s| s['synonym'] }.each do |s|
        unless result_hash.include? s[category]
          new_object = create_taxonomy_from_gbif(s)
          result_hash[new_object.name] = new_object.id if new_object
        end
      end
    end
    result_hash
  end

  def create_taxonomy_from_gbif(gbif_json)
    gbif_fields = %w[kingdom phylum class order family genus species]
    previous_object = nil

    gbif_fields.each_with_index do |gbif_key, idx|
      break unless gbif_json[gbif_key.to_s]
      model = TAXONOMY_MODELS[idx]
      previous_object = model.find_or_create_by(name: gbif_json[gbif_key.to_s]) do |new_object|
        if previous_object
          new_object.send("#{previous_object.class.model_name.param_key}=", previous_object)
        end
      end
    end
    previous_object.save
    previous_object
  end

  # Parse the model from a string restricted to valid taxonomy models
  def parse_model(category)
    parsed = Object.const_get category.camelize
    # category is a valid class, but not part of the taxonomy
    raise TaxonomyCategoryError, 'Invalid taxonomy model' unless TAXONOMY_MODELS.include?(parsed)
    parsed
  rescue NameError
    # category is not a class name
    raise TaxonomyCategoryError, 'Invalid taxonomy model'
  end
end
