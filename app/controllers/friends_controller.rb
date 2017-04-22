class FriendsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find_by user: params[:user]
    render json: {errors: ['指定されたユーザは存在しません']}, status: :bad_request and return if @user.nil?

    @friend = @current_user.friends_from.create to_user_id: @user[:id]
    render json: {errors: @friend.errors.full_messages}, status: :bad_request and return if @friend.errors.any?
    render json: {} and return
  end
end
