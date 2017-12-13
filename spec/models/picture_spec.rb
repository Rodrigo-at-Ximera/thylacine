# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Picture do
  fixtures :pictures, :sightings

  subject {
    described_class.new data: 'picture data', content_type: 'image/png'
  }

  it 'is valid without sighting' do
    expect(subject).to be_valid
  end

  it 'is invalid without data' do
    subject.data = nil
    expect(subject).to_not be_valid
  end

  it 'is invalid without content type' do
    subject.content_type = nil
    expect(subject).to_not be_valid
  end

  it 'is valid with valid sighting' do
    expect(pictures(:two)).to be_valid
  end

  it 'is invalid if replaces an existing picture' do
    # (It would leave an orphaned picture otherwise)
    subject.sighting = sightings(:ba_damselfly)
    expect(subject).to_not be_valid
  end

end
