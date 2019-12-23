# Pictures Controller
class PicturesController < ApplicationController

  skip_before_action :cleanup_uploaded_picture

  def create
    authorize! :new, Picture
    cleanup_uploaded_picture

    picture = ActiveStorage::Blob.create_after_upload!(
      io: params[:picture].tempfile,
      filename: params[:picture].original_filename,
      content_type: params[:picture].content_type
    )
    picture.analyze
    session[:picture_id] = picture.id

    response_data = { id: picture.id, gps: false, src: url_for(picture) }
    if picture.metadata[:latitude]
      response_data[:gps] = true
      response_data[:geoLatitude] = picture.metadata[:latitude]
      response_data[:geoLongitude] = picture.metadata[:longitude]
    end

    render json: response_data
  end
end
