class ApplicationController < ActionController::Base
  before_action :store_location!, if: :storable_location?
  # before_action :authenticate_user!

  def default_url_options
    {path_params: {path: params[:path]}}
  end

  def render_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end

  private
  def storable_location?
    request.get? &&
      is_navigational_format? &&
      !devise_controller? &&
      !request.xhr?
  end

  def store_location!
    store_location_for(:user, request.fullpath)
  end
end
