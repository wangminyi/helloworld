class HomeController < ApplicationController
  before_action :authenticate_user!
  
  def index

  end

  # def login
  #   @user = User.new
  # end
end
