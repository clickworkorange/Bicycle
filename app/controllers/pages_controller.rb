class PagesController < ApplicationController
  require "kramdown"
  require "rouge"
  before_action :set_page, only: %i[ show ]

  def index
    @pages = Page.all
  end

  def show
    # TODO: process image tokens
    unless @page.live || (current_user && current_user.admin)
      flash[:alert] = "You can't be here!"
      redirect_to root_path
    end
  end

  private
    def set_page
      @page = Page.friendly.find(params[:id])
    end
end
