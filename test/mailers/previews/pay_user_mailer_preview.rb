# frozen_string_literal: true

class PayUserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/pay_user_mailer/receipt
  def receipt
    # We need a user to associate the payment with.
    # This will use the first user in your database, or create one if none exist.
    user = User.first || User.create!(email: "preview@example.com", password: "password")

    # Get or create a Pay::Customer record for the user.
    # The pay gem requires a customer object linked to your user model.
    pay_customer = user.set_payment_processor(:fake_processor, allow_fake: true, processor_id: "cus_fake_preview")

    # Create a fake Pay::Charge to simulate a real payment.
    # This creates a record in your development database for the preview.
    charge = Pay::Charge.new(
      id: 12345,
      customer: pay_customer,
      amount: 1500, # $15.00 in cents
      currency: "usd",
      created_at: Time.current,
      # We provide the attributes used by the `charged_to` method
      # instead of setting `charged_to` directly.
      payment_method_type: "card",
      brand: "Visa",
      last4: "4242"
    )

    # Call the mailer with the simulated data.
    # The `with` method passes the charge and customer as params.
    Pay::UserMailer.with(pay_customer: pay_customer, pay_charge: charge).receipt
  end
end
