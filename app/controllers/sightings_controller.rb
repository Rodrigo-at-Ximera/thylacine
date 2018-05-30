# frozen_string_literal:true

# Sightings Controller
class SightingsController < ThylacineController
  include TaxonomyHelper

  skip_before_action :cleanup_uploaded_picture, only: :create

  def index
    authorize! :index, Sighting
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
      cleanup_uploaded_picture
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
            id: @sighting.id, species: @sighting.species.name, picture_id: @sighting.picture.id,
            classification: @sighting.species.genus.full_classification,
            date: (I18n.localize @sighting.created_at, format: :long, locale: I18n.locale),
            picture: url_for(@sighting.picture.variant(resize: '200x200'))
          }
        else
          render json: @sighting
        end
      end
    end
  end

  def recent
    authorize! :read, Sighting
    @sightings = Sighting.with_taxonomy.with_attached_picture.order(created_at: :desc).limit(20)
  end


  private

  def sighting_form_params
    params.require(:sighting_form).permit %i[species species_id genus genus_id family family_id
                                             order order_id t_class t_class_id phylum phylum_id
                                             kingdom kingdom_id geoLatitude geoLongitude picture]
  end

  def sighting_form_save(sighting_form)
    sighting = Sighting.new
    sighting.species = get_or_initialize_species sighting_form
    sighting.geoLatitude = sighting_form.geoLatitude
    sighting.geoLongitude = sighting_form.geoLongitude
    sighting.picture.attach ActiveStorage::Blob.find_by(id: session[:picture_id]) if session[:picture_id]


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
