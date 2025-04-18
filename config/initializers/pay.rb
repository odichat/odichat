Pay.setup do |config|
  config.business_name = "Odichat"
  config.business_address = "9898 Colonnade Blvd, San Antonio, TX 78230"
  config.application_name = "odichat"
  config.support_email = "aeum3893@gmail.com"

  config.default_product_name = "free"
  config.default_plan_name = "free"

  config.enabled_processors = [ :stripe ]

  config.send_emails = false
end
