class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to chatbots_path
  end
end
