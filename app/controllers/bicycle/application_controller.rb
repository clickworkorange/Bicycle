class Bicycle::ApplicationController < ApplicationController
  before_action :check_admin_user

  private
  def check_admin_user
    authenticate_user!
    return if current_user.admin

    flash[:alert] = t("no_access")
    redirect_to root_path
  end
end
