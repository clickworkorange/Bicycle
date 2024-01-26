class ImagesController < ApplicationController
  require "kramdown"
  before_action :set_page
  before_action :set_image, only: %i[show]

  def show
    return if @page.live || current_user&.admin

    flash[:alert] = t("no_access")
    redirect_to root_path
  end

  private
  def set_page
    @page = Page.friendly.find(params[:page_id])
  end

  def set_image
    @image = @page.images.find(params[:id])
  end
end
