class ApplicationController < ActionController::Base
  before_action :store_location!, if: :storable_location?

  def default_url_options
    {path_params: {path: params[:path]}}
  end

  # TODO: how does this handle pages that aren't live?
  # TODO: include page suggestions
  # TODO: track 500 errors etc
  # TODO: track bot 404s separately from genuine traffic
  def render_404
    if request.xhr?
      track_error("XHR not found", request.fullpath)
      head :not_found, content_type: "text/plain" 
    else
      respond_to do |format|
        format.any(:html) do
          track_error("Page not found", request.fullpath)
          @page_title = t("errors.not_found.title")
          render "errors/not_found", formats: :html, content_type: "text/html", layout: "error", status: 404 
        end
        format.any(:pdf, :zip) do
          track_error("File not found", request.fullpath)
          @page_title = t("errors.not_found.title")
          render "errors/not_found", formats: :html, content_type: "text/html", layout: "error", status: 404 
        end
        format.any(:gif, :png, :jpeg) do
          track_error("Image not found", request.fullpath)
          render file: "#{Rails.root}/public/not_found.png", content_type: "image/png", layout: false, status: 404
        end
        format.all do
          track_error("Resource not found", request.fullpath)
          head :not_found, content_type: "text/plain" 
        end
      end
    end
  end
  # TODO: does this cause the 404 to render twice?
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  private
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_location!
    store_location_for(:user, request.fullpath)
  end

  def track_error(message, path)
    # Admin users do not generate a visit
    if current_visit
      ahoy.track("Error", {message: message, path: path})
    end
  end
end
