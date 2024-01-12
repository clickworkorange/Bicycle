class PagesController < ApplicationController
  require "kramdown"
  require "rouge"
  
  before_action :set_page, only: %i[ show ]

  # GET /pages
  def index
    # TODO: live root pages
    @pages = Page.all
  end

  # GET /pages/1
  # TODO: process image tokens
  def show
    # TODO: deny access to non-live pages (unless admin)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.friendly.find(params[:id])
    end
end
