class ContactMailer < ApplicationMailer
  def contact(email, name, subject, message)
    
    User.admin.each do |admin|
    	mail(to: admin.email, from: email_address_with_name(email, name), subject: subject, body: message)
    end
  end
end
