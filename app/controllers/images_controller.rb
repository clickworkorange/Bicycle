class ImagesController < ApplicationController
  require "kramdown"
  before_action :get_page
  before_action :set_image, only: %i[ show  ]
  layout "fullscreen"

  def show
    unless @page.live || (current_user && current_user.admin)
      flash[:alert] = "You can't be here!"
      redirect_to root_path
    end
  end

  private
    def get_page
      @page = Page.friendly.find(params[:page_id])
    end

    def set_image
      @image = @page.images.find(params[:id])
    end
end
