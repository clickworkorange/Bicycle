class ApplicationController < ActionController::Base
  before_action :store_location!, if: :storable_location?

  def default_url_options
    {path_params: {path: params[:path]}}
  end

  def render_404
    #redirect_to controller: :errors, action: :not_found
    respond_to do |format|
      format.html { render "errors/not_found", layout: "error", status: 404 }
      format.all { head :not_found, content_type: "text/plain" }
    end
  end
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  private
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_location!
    store_location_for(:user, request.fullpath)
  end
end
