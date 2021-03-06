# frozen_string_literal: true

module AboutHelper
  ABOUT_LINKS = {
    rails:            ['Ruby on Rails (v6.0)', 'http://rubyonrails.org/'],
    postgresql:       ['PostgreSQL (v10.1)', 'https://www.postgresql.org/'],
    devise:           ['Devise (v4.7)', 'https://github.com/plataformatec/devise'],
    omniauth:         ['OmniAuth (v1.9)', 'https://github.com/omniauth/omniauth'],
    cancancan:        ['CanCanCan (v3.0)', 'https://github.com/CanCanCommunity/cancancan'],
    exifr:            ['EXIF Reader (v1.3)', 'https://github.com/remvee/exifr'],
    rest_client:      ['REST Client (v2.1)', 'https://github.com/rest-client/rest-client'],
    bootstrap:        ['Bootstrap (v4.4)', 'https://getbootstrap.com/'],
    jquery:           ['jQuery (v1.12)', 'https://jquery.com/'],
    jqueryui:         ['jQuery UI (v1.12)', 'http://jqueryui.com/'],
    google_maps:      ['Google Maps API (v3)', 'https://developers.google.com/maps/'],
    markerclusterer:  ['Marker Clusterer (v1.0)', 'https://github.com/googlemaps/js-marker-clusterer'],
    gbif:             ['GBIF API', 'https://www.gbif.org/developer/summary'],
    heroku:           ['Heroku', 'https://www.heroku.com/'],
    linkedin:         ['LinkedIn', 'https://www.linkedin.com/in/rodrigocharon/'],
    upwork:           ['Upwork', 'https://www.upwork.com/o/profiles/users/_~01b1339734965265fb/'],
    rspec:            ['RSpec (v3.9)', 'http://rspec.info/']
  }.freeze

  def about_link(key)
    link_to ABOUT_LINKS.fetch(key)[0], ABOUT_LINKS.fetch(key)[1], target: '_blank'
  end
end
