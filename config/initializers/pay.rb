Pay.setup do |config|
  config.business_name = "Odichat"
  config.business_address = "San Antonio, TX 78230\nUSA"
  config.application_name = "Odichat"
  config.support_email = "Odichat <odichat.app@gmail.com>"

  config.default_product_name = "default"
  config.default_plan_name = "default"

  config.enabled_processors = [ :stripe ]

  config.send_emails = true
end
