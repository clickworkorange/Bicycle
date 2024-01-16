class Bicycle::ApplicationController < ApplicationController
	before_action :check_admin_user

  private
  def check_admin_user
  	authenticate_user!
    unless current_user.admin
      flash[:alert] = "You can't be here!"
      redirect_to root_path
    end
  end
end