# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SightingsController do
  fixtures :species, :users, :pictures, :sightings, :orders, :t_classes

  describe 'POST create' do

    it 'creates a sighting from a sighting form and the session' do
      sign_in users(:spotter), scope: :user

      params = { sighting_form: { species_id: species(:cat).id,
                                  geoLatitude: -33,
                                  geoLongitude: 77 } }

      session[:picture_id] = pictures(:one).id

      post :create, params: params
      expect(response).to redirect_to sightings_url
      created = Sighting.last
      expect(created.species).to eq species(:cat)
      expect(created.geoLatitude).to eq -33
      expect(created.geoLongitude).to eq 77
      expect(created.picture).to eq pictures(:one)

    end

    it 'allows taxonomists to create new categories' do
      sign_in users(:taxonomist), scope: :user
      params = { sighting_form: { species: 'new species',
                                  genus: 'new genus',
                                  family: 'new family',
                                  order_id: orders(:carnivora),
                                  t_class: 'new class',
                                  geoLatitude: -33,
                                  geoLongitude: 77 } }

      session[:picture_id] = pictures(:one).id

      post :create, params: params
      expect(response).to redirect_to sightings_url
      created = Sighting.last
      expect(created.species.name).to eq 'new species'
      expect(created.species.genus.name).to eq 'new genus'
      expect(created.species.genus.family.name).to eq 'new family'
      expect(created.species.genus.family.order).to eq orders(:carnivora)
      expect(created.species.genus.family.order.t_class.name).to_not eq 'new class'

    end

    it 'fails if the new taxonomy is incomplete' do
      sign_in users(:taxonomist), scope: :user
      params = { sighting_form: { species: 'new species',
                                  family: 'new family',
                                  order_id: orders(:carnivora),
                                  t_class: 'new class',
                                  geoLatitude: -33,
                                  geoLongitude: 77 } }

      session[:picture_id] = pictures(:one).id

      post :create, params: params
      expect(response).to render_template :new
      expect(assigns(:sighting_form).errors).to include :genus
      expect(assigns(:sighting_form).errors[:genus]).to include 'can\'t be blank'
    end

    it 'ONLY allows taxonomists to create new categories' do
      sign_in users(:spotter), scope: :user
      params = { sighting_form: { species: 'new species',
                                  genus: 'new genus',
                                  family: 'new family',
                                  order_id: orders(:carnivora),
                                  t_class: 'new class',
                                  geoLatitude: -33,
                                  geoLongitude: 77 } }

      session[:picture_id] = pictures(:one).id

      post :create, params: params
      expect(response).to render_template :new
      expect(assigns(:sighting_form).errors).to include :species
      expect(assigns(:sighting_form).errors[:species]).to include (I18n.translate :taxonomy_manage_auth_fail, model: 'Species')

    end

  end

end