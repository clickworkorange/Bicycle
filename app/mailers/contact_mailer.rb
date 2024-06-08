class ContactMailer < ApplicationMailer
  def send_contact
    @contact = Contact.new(params[:contact])
    User.admin.each do |admin|
    	mail(
        to: admin.email, 
        from: email_address_with_name(@contact.email, @contact.name), 
        subject: @contact.subject, 
        body: @contact.message
      )
    end
  end
end
