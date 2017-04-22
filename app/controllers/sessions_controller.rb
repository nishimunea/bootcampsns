class SessionsController < ApplicationController
  before_action :authenticate_user!, only: [:clear]

  def create
    begin
      @user = User.find_by "user='#{params[:user]}' and pass='#{ Digest::MD5.hexdigest params[:pass] }'"
      log_in @user
      render json: {name: @user.name, icon: icon_user_path(@user)} and return
    rescue
      render json: {errors: ['ログインに失敗しました']}, status: :bad_request and return
    end
  end

  def clear
    log_out
    render json: {} and return
  end
end
