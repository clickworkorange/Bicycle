# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  def destroy
    # set_flash_message :notice, :signed_out
    # flash.keep(:notice)
    # sign_out_and_redirect(current_user)
    flash[:notice] = t("devise.sessions.signed_out")
    sign_out current_user
    redirect_to after_sign_out_path_for(:user)
  end

  protected
  def after_sign_out_path_for(resource_or_scope)
    stored_location_for(resource_or_scope)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
