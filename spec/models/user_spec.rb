# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  fixtures :users

  subject {
    described_class.new email: 'newuser@newuser.com',
                        encrypted_password: User.new.send(:password_digest, 'password')
  }

  it 'has spotter as a default role' do
    subject.save
    expect(subject.role).to eq 'spotter'
  end

  it 'inherits lower roles' do
    expect(users(:admin).role?('admin')).to be true
    expect(users(:admin).role?('taxonomist')).to be true
    expect(users(:admin).role?('spotter')).to be true

    expect(users(:taxonomist).role?('admin')).to be false
    expect(users(:taxonomist).role?('taxonomist')).to be true
    expect(users(:taxonomist).role?('spotter')).to be true

    expect(users(:spotter).role?('admin')).to be false
    expect(users(:spotter).role?('taxonomist')).to be false
    expect(users(:spotter).role?('spotter')).to be true
  end

end
