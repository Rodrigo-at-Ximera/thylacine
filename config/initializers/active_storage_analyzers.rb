# frozen_string_literal: true

require 'exifr/jpeg'

module ActiveStorage
  class GPSAnalyzer < Analyzer::ImageAnalyzer
    def metadata
      meta = super || {}
      meta.merge(read_image do |image|
        gps_from_exif image || {}
      end)
    end

    private

    def gps_from_exif(image)
      return unless image.type == 'JPEG'

      if exif = EXIFR::JPEG.new(image.path).exif
        if exif && gps = exif.gps
          {
            latitude:  gps.latitude,
            longitude: gps.longitude,
            altitude:  gps.altitude
          }
        end
      end
    rescue EXIFR::MalformedImage, EXIFR::MalformedJPEG
    end
  end
end

Rails.application.config.active_storage.analyzers.delete ActiveStorage::Analyzer::ImageAnalyzer
Rails.application.config.active_storage.analyzers.append ActiveStorage::GPSAnalyzer


