class HomeController < ApplicationController
  before_action :authenticate_user!
  
  def index

  end

  # POST /send_message
  # 发送消息给图灵机器人
  def send_message
    message = params[:message]
    if message.present?
      status = :success
      result = RestClient.get "http://www.tuling123.com/openapi/api", {:params => { :key => '6c78bae3a1fc2e4b2b7ca3b70dd195c1', :info => message}}
    else
      status = :fail
      result = ""
    end
    respond_to do |format|
      format.json { render json: {status: status, result: result.force_encoding("UTF-8")}, status: :ok}
    end
  end
  # def login
  #   @user = User.new
  # end
end
