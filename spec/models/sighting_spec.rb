# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sighting do
  fixtures :species, :users, :pictures, :sightings

  subject {
    described_class.new species: species(:cat), user: users(:spotter), picture: pictures(:one),
                        geoLatitude: 0, geoLongitude: 0
  }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'is invalid without species' do
    subject.species = nil
    expect(subject).to_not be_valid
  end

  it 'is invalid without user' do
    subject.user = nil
    expect(subject).to_not be_valid
  end

  it 'is invalid without geo' do
    subject.geoLatitude = nil
    subject.geoLongitude = nil
    expect(subject).to_not be_valid
  end

  it 'is invalid without picture' do
    subject.picture = nil
    expect(subject).to_not be_valid
  end

  it 'is invalid with a used picture' do
    subject.picture = pictures(:two)
    expect(subject).to_not be_valid
  end
end
