# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :set_navs

  # CanCanCan: ensure authorization happens on every action
  check_authorization unless: :devise_controller?

  def set_locale
    I18n.locale = params[:l] || I18n.default_locale
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
