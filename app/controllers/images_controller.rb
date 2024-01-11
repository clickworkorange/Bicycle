class ImagesController < ApplicationController
  before_action :get_page
  before_action :set_image, only: %i[ show  ]

  # GET /images/1
  def show
  end

  private
    def get_page
      @page = Page.friendly.find(params[:page_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = @page.images.find(params[:id])
    end
end
