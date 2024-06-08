class ContactController < ApplicationController
  layout "private"

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.valid? 
      ContactMailer.with(contact_params).send_contact.deliver_later
      redirect_to :root, notice: t("contact.sent")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:email, :name, :subject, :message)
  end
end
