class CommentsController < ApplicationController
  require "kramdown"
  require "rouge"
  before_action :set_page
  before_action :auth_user
  
  def create 
    puts "LUBA: #{current_user}"
  end

  private
  def set_page
    @page = Page.friendly.find(params[:id], allow_nil: true) || Page.for_url("/#{params[:id]}").first
  end

  def auth_user
    authenticate_user!
    # return unless current_user

    # flash[:alert] = t("no_access")
    # redirect_to @page
  end
end