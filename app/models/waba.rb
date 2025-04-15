require "net/http"
require "uri"

class Waba < ApplicationRecord
  include WhatsappClient

  belongs_to :chatbot

  before_destroy :unsubscribe

  def self.available_verticals
    {
      "ALCOHOL" => "Alcoholic Beverages",
      "APPAREL" => "Clothing and Apparel",
      "AUTO" => "Automotive",
      "BEAUTY" => "Beauty, Spa and Salon",
      "EDU" => "Education",
      "ENTERTAIN" => "Entertainment",
      "EVENT_PLAN" => "Event Planning and Service",
      "FINANCE" => "Finance and Banking",
      "GOVT" => "Public Service",
      "GROCERY" => "Food and Grocery",
      "HEALTH" => "Medical and Health",
      "HOTEL" => "Hotel and Lodging",
      "NONPROFIT" => "Non-profit",
      "ONLINE_GAMBLING" => "Online Gambling & Gaming",
      "OTC_DRUGS" => "Over-the-Counter Drugs",
      "OTHER" => "Other",
      "PHYSICAL_GAMBLING" => "Non-Online Gambling & Gaming (E.g. Brick and mortar)",
      "PROF_SERVICES" => "Professional Services",
      "RESTAURANT" => "Restaurant",
      "RETAIL" => "Shopping and Retail",
      "TRAVEL" => "Travel and Transportation"
    }
  end

  def get_business_profile
    client = whatsapp_client(self.access_token)
    client.business_profiles.get(self.phone_number_id)
  end

  def update_business_profile(params)
    client = whatsapp_client(self.access_token)
    if params[:websites].present?
      params[:websites] = params[:websites].split(",").map(&:strip)
    end

    if params[:profile_picture_handle].present?
      handle = upload_profile_picture(params[:profile_picture_handle])
      params.merge!(profile_picture_handle: handle)
    end
    # business_profiles.update responds with Boolean
    client.business_profiles.update(
      phone_number_id: self.phone_number_id,
      params: params
    )
  end

  def get_connected_phone_number
    client = whatsapp_client(self.access_token)
    client.phone_numbers.get(self.phone_number_id)
  end

  def upload_profile_picture(file)
    upload_session_id = start_upload_session(file.original_filename, file.size, file.content_type)
    upload_file(upload_session_id, file.path)["h"]
  rescue StandardError => e
    raise "Error uploading profile picture: #{e}"
  end

  def subscribe
    uri = URI("https://graph.facebook.com/v22.0/#{self.waba_id}/subscribed_apps")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request.body = { access_token: self.access_token }.to_json

    response = http.request(request)
    parsed_response = JSON.parse(response.body)
    if !response.is_a?(Net::HTTPSuccess) || parsed_response["error"]
      error_message = parsed_response["error"] || "Unknown error"
      error_code = parsed_response["error"]&.dig("code") || response.code
      raise "WhatsApp API Error (#{error_code}): #{error_message}"
    end
    self.subscribed = true
    self.save!
    parsed_response
  rescue JSON::ParserError => e
    raise "Invalid JSON response: #{e.message}"
  rescue StandardError => e
    raise "Error subscribing: #{e}"
  end

  def unsubscribe
    uri = URI("https://graph.facebook.com/v22.0/#{self.waba_id}/subscribed_apps")

    # Set up the DELETE request
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Delete.new(uri)
    request["Content-Type"] = "application/json"
    request.body = { access_token: self.access_token }.to_json

    response = http.request(request)
    parsed_response = JSON.parse(response.body)
    if !response.is_a?(Net::HTTPSuccess) || parsed_response["error"]
      error_message = parsed_response["error"] || "Unknown error"
      error_code = parsed_response["error"]&.dig("code") || response.code
      raise "WhatsApp API Error (#{error_code}): #{error_message}"
    end
    self.subscribed = false
    self.save!
    parsed_response
  rescue JSON::ParserError => e
    raise "Invalid JSON response: #{e.message}"
  rescue StandardError => e
    raise "Error unsubscribing: #{e}"
  end

  private

  def start_upload_session(filename, size, content_type)
    uri = URI("https://graph.facebook.com/v22.0/#{Rails.application.credentials.whatsapp[:app_id]}/uploads")
    params = {
      access_token: Rails.application.credentials.whatsapp[:access_token],
      file_size: size,
      file_type: content_type
    }
    response = Net::HTTP.post(uri, params.to_json, "Content-Type" => "application/json")
    parsed_response = JSON.parse(response.body)
    if !response.is_a?(Net::HTTPSuccess) || parsed_response["error"]
      error_message = parsed_response["error"] || "Unknown error"
      error_code = parsed_response["error"]&.dig("code") || response.code
      raise "WhatsApp API Error (#{error_code}): #{error_message}"
    end

    parsed_response["id"]
  rescue JSON::ParserError => e
    raise "Invalid JSON response: #{e.message}"
  rescue StandardError => e
    raise "Error starting upload session: #{e}"
  end

  def upload_file(upload_session_id, file_path)
    uri = URI("https://graph.facebook.com/v22.0/#{upload_session_id}")
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "OAuth #{Rails.application.credentials.whatsapp[:access_token]}"
    request["file_offset"] = "0"
    request["Content-Type"] = "application/octet-stream"

    # Read the file in binary mode
    request.body = File.binread(file_path)
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    parsed_response = JSON.parse(response.body)
    if !response.is_a?(Net::HTTPSuccess) || parsed_response["error"]
      error_message = parsed_response["error"]&.dig("message") || "Unknown error"
      error_code = parsed_response["error"]&.dig("code") || response.code
      raise "WhatsApp API Error (#{error_code}): #{error_message}"
    end

    parsed_response
  rescue JSON::ParserError => e
    raise "Invalid JSON response: #{e.message}"
  rescue StandardError => e
    raise "Error uploading file: #{e}"
  end
end
