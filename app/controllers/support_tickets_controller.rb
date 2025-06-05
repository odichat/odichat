class SupportTicketsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    ticket_data = support_ticket_params.to_h.merge(user_id: current_user.id)
    Discord::NewSupportTicketNotificationJob.perform_later(
      name: ticket_data[:name],
      phone_number: ticket_data[:phone_number],
      subject: ticket_data[:subject],
      message: ticket_data[:message],
      user_id: ticket_data[:user_id]
    )
    redirect_to new_support_ticket_path, notice: "Support ticket was successfully created."
  end

  private

  def support_ticket_params
    params.permit(:name, :phone_number, :subject, :message)
  end
end
