class NotificationMailer < ApplicationMailer
  # layout "notification"

  def registration_notification
    @user = params[:user]
    User.admin.each do |admin|
    	mail(to: admin.email, subject: "Registration notification")
    end
  end

  def comment_notification
    @comment = params[:comment]
    User.admin.each do |admin|
    	mail(to: admin.email, subject: "Comment notification")
    end
  end
end
