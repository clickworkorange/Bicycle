class Helm::ApplicationController < ApplicationController
	before_action :check_admin_user
  before_action :fetch_pages
  before_action :fetch_users

  private
  def fetch_pages
    @pages = Page.where(parent_id: nil)
  end
  def fetch_users
    @users = User.all
  end

  def check_admin_user
  	authenticate_user!
    unless current_user.admin
      flash[:alert] = "You can't be here!"
      redirect_to root_path
    end
  end
end