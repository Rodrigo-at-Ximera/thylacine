# frozen_string_literal:true

require 'exifr/jpeg'

# Sightings Controller
class SightingsController < ThylacineController
  include TaxonomyHelper

  def index
    authorize! :index, Sighting
    @kingdoms = Kingdom.all
  end

  def new
    authorize! :new, Sighting
    @sighting_form = SightingForm.new
  end

  def create
    authorize! :create, Sighting
    @sighting_form = SightingForm.new
    @sighting_form.assign_attributes sighting_form_params

    if sighting_form_save @sighting_form
      cleanup_tempfile
      flash[:notice] = I18n.t :save_success, model: Sighting.model_name.human
      redirect_to sightings_url
    else
      flash[:alert] = I18n.t :save_failed, model: Sighting.model_name.human
      render action: :new
    end
  end

  def show
    @sighting = Sighting.with_taxonomy.find(params[:id])
    authorize! :show, @sighting
    respond_to do |format|
      format.json do
        if params[:info]
          render json: {
            id: @sighting.id, species: @sighting.species.name,
            classification: @sighting.species.genus.full_classification,
            date: (I18n.localize @sighting.created_at, format: :long)
          }
        else
          render json: @sighting, except: :pictureData
        end
      end
    end
  end

  def upload_picture
    authorize! :new, Sighting

    file_name = save_tempfile(params[:pictureFile])
    session[:picture_file_path] = file_name
    session[:picture_content_type] = params[:pictureFile].content_type

    response_data = { gps: false }
    if params[:pictureFile].content_type == 'image/jpeg'
      e = EXIFR::JPEG.new(file_name)
      if e.exif? && e.exif.gps
        response_data[:gps] = true
        response_data[:geoLatitude] = e.exif.gps.latitude
        response_data[:geoLongitude] = e.exif.gps.longitude
      end
    end

    render json: response_data
  end

  def picture
    authorize! :read, Sighting
    @sighting = Sighting.find_by(id: params[:id]) if params[:id]
    if @sighting
      data = @sighting.pictureData
      filename = "#{@sighting.species.name}-#{@sighting.created_at}"
      type = @sighting.pictureContentType
    elsif session[:picture_file_path] && File.exist?(session[:picture_file_path])
      data = File.binread session[:picture_file_path]
      filename = 'uploaded_image'
      type = session[:picture_content_type]
    else
      data = Rails.application.assets['picture_add.png'].source
      filename = 'picture_add.png'
      type = 'image/png'
    end

    send_data data, filename: filename, type: type, disposition: :inline
  end

  def cleanup_tempfile
    authorize! :new, Sighting
    return unless session[:picture_file_path]
    File.delete session[:picture_file_path] if File.exist? session[:picture_file_path]
    session[:picture_file_path] = nil
    session[:picture_content_type] = nil
  end

  def recent
    authorize! :read, Sighting
    @sightings = Sighting.with_taxonomy.order(created_at: :desc).limit(20)
  end

  private

  def save_tempfile(uploaded_file)
    file_name = Rails.root.join('tmp', 'uploads', SecureRandom.uuid)
    File.open(file_name, 'w') do |f|
      f.binmode
      f.write uploaded_file.tempfile.read
    end
    file_name.to_s
  end

  def sighting_form_params
    params.require(:sighting_form).permit %i[species species_id genus genus_id family family_id
                                             order order_id t_class t_class_id phylum phylum_id
                                             kingdom kingdom_id geoLatitude geoLongitude]
  end

  def sighting_form_save(sighting_form)
    sighting = Sighting.new
    sighting.species = get_or_initialize_species sighting_form
    sighting.geoLatitude = sighting_form.geoLatitude
    sighting.geoLongitude = sighting_form.geoLongitude

    if session[:picture_file_path] && File.exist?(session[:picture_file_path])
      sighting.pictureData = sighting_form.picture = File.binread session[:picture_file_path]
      sighting.pictureContentType = session[:picture_content_type]
    end

    sighting.user = current_user

    if sighting.valid? && sighting_form.errors.size.zero?
      sighting.save
    else
      sighting.errors.each { |attribute, error| sighting_form.errors.add attribute, error }
      false
    end
  end

  def get_or_initialize_species(sighting_form)
    need_init = []
    object = nil
    TAXONOMY_MODELS.reverse_each do |model|
      model_id = sighting_form.send("#{model.model_name.param_key}_id")
      object = model.find_by id: model_id if model_id
      break if object
      need_init.unshift(model)
    end

    need_init.each do |model|
      object = model.new do |new_object|
        new_object.name = sighting_form.send(model.model_name.element)
        new_object.send("#{object.class.model_name.param_key}=", object) if object
      end
      unless object.valid?
        object.errors.each do |_attribute, error|
          sighting_form.errors.add object.class.model_name.element, error
        end
      end
      next if can? :create, model
      sighting_form.errors.add model.model_name.element,
                               (I18n.t :taxonomy_manage_auth_fail,
                                       model: model.model_name.human.pluralize(locale.to_sym))
    end

    raise if object.class != Species
    object
  end
end
