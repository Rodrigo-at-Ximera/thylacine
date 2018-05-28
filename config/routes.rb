# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :sightings, except: %i[edit update destroy] do
    get :recent, on: :collection
  end

  resources :pictures, only: %i[create show] do
    get :cleanup_uploaded, on: :collection
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
