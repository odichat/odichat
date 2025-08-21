class UserNotifierMailer < ApplicationMailer
  def display_name_approval_needed
    @user = params[:user]
    @waba = params[:waba]
    mail(to: @user.email, subject: "WhatsApp Display Name Approval Required")
  end
end
