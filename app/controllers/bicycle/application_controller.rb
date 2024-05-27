class Bicycle::ApplicationController < ApplicationController
  before_action :check_admin_user
  skip_before_action :track_ahoy_visit

  content_security_policy do |policy|
    # Allow chartkick inline JS
    policy.script_src  :self, :unsafe_inline
  end

  private
  def check_admin_user
    authenticate_user!
    return if current_user.admin

    flash[:alert] = t("no_access")
    redirect_to root_path
  end
end
