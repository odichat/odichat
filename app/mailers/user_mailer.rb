class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome_email.subject
  #
  def welcome_email
    @user = params[:user]

    mail(
      to: @user.email,
      subject: "¡Bienvenido a Odichat! Atiende 24/7 sin levantar un dedo"
    )
  end
end
