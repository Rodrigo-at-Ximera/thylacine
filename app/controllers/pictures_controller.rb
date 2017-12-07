# frozen_string_literal:true

require 'exifr/jpeg'

# Pictures Controller
class PicturesController < ApplicationController

  skip_before_action :cleanup_uploaded_picture

  def create
    authorize! :new, Picture
    cleanup_uploaded_picture

    picture = Picture.create data: params[:pictureFile].tempfile.read,
                             content_type: params[:pictureFile].content_type

    session[:picture_id] = picture.id

    response_data = { gps: false }
    if params[:pictureFile].content_type == 'image/jpeg'
      e = EXIFR::JPEG.new(params[:pictureFile].tempfile.path)
      if e.exif? && e.exif.gps
        response_data[:gps] = true
        response_data[:geoLatitude] = e.exif.gps.latitude
        response_data[:geoLongitude] = e.exif.gps.longitude
      end
    end

    render json: response_data
  end

  def show
    picture = Picture.find params[:id]
    authorize! :read, picture
    send_data picture.data, filename: 'uploaded_image', type: picture.content_type, disposition: :inline
  end
end
