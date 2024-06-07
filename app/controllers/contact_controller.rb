class ContactController < ApplicationController
  layout "private"

  def new
    @contact = Contact.new
  end

  def create
    # @email = params[:contact][:email]
    # @name = params[:contact][:name]
    # @subject = params[:contact][:subject]
    # @message = params[:contact][:message]
    @contact = Contact.new(contact_params)
    #Comment.new(comment_params.merge(page_id: @page.id, user_id: current_user.id))
    if @contact.valid? 
      ContactMailer.with(@contact).contact.deliver_later
      flash[:success] = t("contact.sent")
      redirect_to :root
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:email, :name, :subject, :message)
  end
end
