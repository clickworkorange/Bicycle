class ApplicationController < ActionController::Base
  before_action :fetch_live_pages

  private
  def fetch_live_pages
  	@live_pages = Page.where(live: true, parent_id: nil)
  end
end
