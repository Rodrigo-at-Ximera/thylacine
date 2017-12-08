# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :set_navs
  before_action :cleanup_uploaded_picture, unless: -> { request.xhr? }

  # CanCanCan: ensure authorization happens on every action
  check_authorization unless: :devise_controller?

  def set_locale
    I18n.locale = params[:l] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def default_url_options
    { l: I18n.locale }
  end

  def set_navs
    @nav_items = { 'browse': %w[sightings index],
                   'new_sighting': %w[sightings new create],
                   'recent_sightings': %w[sightings recent],
                   'about': %w[about index] }

    @nav_icons = if current_user
                   {
                     # 'icon-bell': [root_path, :get],
                     # 'icon-user': [root_path, :get],
                     'icon-exit': [destroy_user_session_path, :delete]
                   }
                 elsif !devise_controller?
                   { 'icon-enter': [new_user_session_path, :get] }
                 else
                   {}
                 end
  end


  protected

  def cleanup_uploaded_picture
    return unless session[:picture_id]
    picture = Picture.find_by(id: session[:picture_id])
    picture.delete if picture && picture.sighting.nil?
    session[:picture_id] = nil
  end


  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      flash[:alert] = exception.message
      redirect_to root_url
    else
      flash[:alert] = I18n.translate :must_sign_in
      redirect_to new_user_session_path
    end
  end
end
