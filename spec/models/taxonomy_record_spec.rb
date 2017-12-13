# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaxonomyRecord do
  fixtures :families, :genus, :kingdoms, :orders, :phylums, :species, :t_classes

  it 'has a full classification' do
    full_classification = species(:cat).full_classification
    expect(full_classification).to eq(['Felis catus',
                                       'Felis',
                                       'Felidae',
                                       'Carnivora',
                                       'Mammalia',
                                       'Chordata',
                                       'Animalia'])
  end


end
