# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :sightings do
    post :upload_picture, on: :new
    get :cleanup_tempfile, on: :new
    get :picture, on: :member
    get :picture, on: :new
    get :recent, on: :collection
  end

  scope 'taxonomy' do
    get 'autocomplete/:category',   to: 'taxonomy#autocomplete',
                                    as: 'taxonomy_autocomplete'
    get 'ancestors/:category/:id',  to: 'taxonomy#ancestors',
                                    as: 'taxonomy_ancestors'
    get 'children/:category/:id',   to: 'taxonomy#children',
                                    as: 'taxonomy_children'
    get 'sightings/:category/:id',  to: 'taxonomy#sightings',
                                    as: 'taxonomy_sightings'
  end

  get 'about', to: 'about#index'

  root to: 'home#index'
end
