class ApplicationController < ActionController::Base
  before_action :store_location!, if: :storable_location?

  # TODO: implement traffic logging with https://github.com/ankane/ahoy

  def default_url_options
    {path_params: {path: params[:path]}}
  end

  # TODO: how does this handle pages that aren't live?
  # TODO: include page suggestions
  # TODO: improve ahoy tracking
  def render_404
    if request.xhr?
      ahoy.track "XHR not found"
      head :not_found, content_type: "text/plain" 
    else
      respond_to do |format|
        format.any(:html, :pdf, :zip) do
          ahoy.track "File not found"
          @page_title = t("errors.not_found.title")
          render "errors/not_found", formats: :html, content_type: "text/html", layout: "error", status: 404 
        end
        format.any(:gif, :png, :jpeg) do
          ahoy.track "Image not found"
          render file: "#{Rails.root}/public/not_found.png", content_type: "image/png", layout: false, status: 404
        end
        format.all do
          ahoy.track "Resource not found"
          head :not_found, content_type: "text/plain" 
        end
      end
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
