# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaxonomyController do
  fixtures :families, :genus, :kingdoms, :orders, :phylums, :species, :t_classes

  describe 'GET children' do

    it 'responds with all kingdoms when the category is Life' do
      get :children, params: { category: 'life', id: 'anything' }
      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/json; charset=utf-8'
      expect(JSON.parse(response.body)).to eq [
        { id: kingdoms(:animal).id, name: 'Animalia', category: 'kingdom', has_children: true },
        { id: kingdoms(:plant).id, name: 'Plantae', category: 'kingdom', has_children: true }
      ].as_json
    end

    it 'responds with 404 if the category is invalid' do
      get :children, params: { category: 'invalid', id: 'anything' }
      expect(response.status).to eq 404
    end

    it 'responds with the classes of a phylum' do
      get :children, params: { category: 'phylum', id: phylums(:chordata) }
      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/json; charset=utf-8'
      expect(JSON.parse(response.body)).to eq [
        { id: t_classes(:mammal).id, name: 'Mammalia', category: 't_class', has_children: true }
      ].as_json
    end

    it 'responds with the families of an order' do
      get :children, params: { category: 'order', id: orders(:carnivora) }
      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/json; charset=utf-8'
      expect(JSON.parse(response.body)).to eq [
        { id: families(:felidae).id, name: 'Felidae', category: 'family', has_children: true }
      ].as_json
    end

    it 'responds with the species of a genus' do
      get :children, params: { category: 'genus', id: genus(:felis) }
      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/json; charset=utf-8'
      expect(JSON.parse(response.body)).to eq [
        { id: species(:cat).id, name: 'Felis catus', category: 'species', has_children: false }
      ].as_json
    end

  end

  describe 'GET ancestors' do

    it 'gets the ancestors of a species' do
      get :ancestors, params: { category: 'species', id: species(:cat) }
      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/json; charset=utf-8'
      expect(JSON.parse(response.body)).to eq [
        { id: genus(:felis).id, label: 'Felis', category: 'genus' },
        { id: families(:felidae).id, label: 'Felidae', category: 'family' },
        { id: orders(:carnivora).id, label: 'Carnivora', category: 'order' },
        { id: t_classes(:mammal).id, label: 'Mammalia', category: 't_class' },
        { id: phylums(:chordata).id, label: 'Chordata', category: 'phylum' },
        { id: kingdoms(:animal).id, label: 'Animalia', category: 'kingdom' }
      ].as_json
    end

    it 'responds with 404 if the category is invalid' do
      get :ancestors, params: { category: 'invalid', id: 'anything' }
      expect(response.status).to eq 404
    end

  end

end