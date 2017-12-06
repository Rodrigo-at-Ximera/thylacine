# frozen_string_literal: true

module GoogleMapHelper
  BASE_STATIC_URL = 'https://maps.googleapis.com/maps/api/staticmap'
  BASE_JAVASCRIPT_URL = 'https://maps.googleapis.com/maps/api/js'

  def static_map_image(latitude, longitude, options)
    src = URI(BASE_STATIC_URL)
    src.query = URI.encode_www_form(center: "#{latitude},#{longitude}",
                                    zoom: 10,
                                    size: '150x150',
                                    language: I18n.locale,
                                    key: Rails.application.secrets.google_maps_api_key)

    image_tag src, options
  end

  def map_javascript
    src = URI(BASE_JAVASCRIPT_URL)
    src.query = URI.encode_www_form(language: I18n.locale,
                                    key: Rails.application.secrets.google_maps_api_key)
    javascript_include_tag src
  end
end
