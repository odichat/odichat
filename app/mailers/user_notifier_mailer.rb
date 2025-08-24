class UserNotifierMailer < ApplicationMailer
  def display_name_approval_needed
    @user = params[:user]
    @channel = params[:channel]
    mail(to: @user.email, subject: "WhatsApp Display Name Approval Required")
  end
end
