class ApplicationController < ActionController::Base
  before_action :store_location!, if: :storable_location?

  def default_url_options
    {path_params: {path: params[:path]}}
  end

  def render_404
    if request.xhr?
      head :not_found, content_type: "text/plain" 
    else
      respond_to do |format|
        format.any(:html, :pdf, :zip) do
          @page_title = t("errors.not_found.title")
          render "errors/not_found", formats: :html, content_type: "text/html", layout: "error", status: 404 
        end
        format.any(:gif, :png, :jpeg) do
          render file: "#{Rails.root}/public/not_found.png", content_type: "image/png", layout: false, status: 404
        end
        format.all do
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
