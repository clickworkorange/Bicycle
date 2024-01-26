class PagesController < ApplicationController
  require "kramdown"
  require "rouge"
  before_action :set_page, only: %i[show]

  def index
    @page = Page.for_url("/").first
    if @page
      render @page.template, locals: {page: @page}
    else
      render_404
    end
  end

  def show
    if @page
      unless @page.live || current_user&.admin
        flash[:alert] = t("no_access")
        redirect_to root_path
      end
      render @page.template, locals: {page: @page}
    else
      render_404
    end
  end

  private
  def set_page
    @page = Page.friendly.find(params[:id], allow_nil: true) || Page.for_url("/#{params[:id]}").first
  end
end
