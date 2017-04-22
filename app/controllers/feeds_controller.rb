class FeedsController < ApplicationController
  before_action :authenticate_user!

  def create
    case params[:feed_type]
      when 'text'
        @feed = @current_user.feed.create feed_type: 'text', comment: params[:comment]
        render json: {errors: @feed.errors.full_messages}, status: :bad_request and return if @feed.errors.any?
      when 'image'
        begin
          img = Magick::Image.from_blob(File.read params[:image].tempfile).shift
          exif = "#{img.properties['exif:Make']||=''} #{img.properties['exif:Model']||=''}"
          img.format = "JPEG"
          img.resize_to_fit!(500, 500)
          file_name = "#{SecureRandom.uuid}.jpg"
          img.write "#{Rails.root}/public/images/#{file_name}"
          @feed = @current_user.feed.create feed_type: 'image', exif: exif, image_file_name: file_name
          render json: {errors: @feed.errors.full_messages}, status: :bad_request and return if @feed.errors.any?
        rescue
          render json: {errors: ['画像フォーマットが正しくありません']}, status: :bad_request and return
        end
      else
        render json: {errors: ['Feed種別が正しくありません']}, status: :bad_request and return
    end
    render json: {} and return
  end

  def index
    @feeds = Feed.joins(:user).where("user_id IN (#{scope_user_ids.join(', ')})").select('feeds.*,users.name').order('id DESC').limit(30)
    render json: {count: @feeds.count, feeds: @feeds} and return
  end

  def find_new
    @feeds = Feed.joins(:user).where("user_id IN (#{scope_user_ids.join(', ')}) and feeds.id > ?", params[:id].to_i).select('feeds.*,users.name').order('id DESC')
    render json: {count: @feeds.length, feeds: @feeds} and return if params[:include_items] == '1'
    render json: {count: @feeds.length} and return
  end

  def find_old
    @feeds = Feed.joins(:user).where("user_id IN (#{scope_user_ids.join(', ')}) and feeds.id < ?", params[:id].to_i).select('feeds.*,users.name').order('id DESC').limit(30)
    render json: {count: @feeds.length, feeds: @feeds} and return if params[:include_items] == '1'
    render json: {count: @feeds.length} and return
  end

  private

  def scope_user_ids
    ids = @current_user.friends_from_user_ids + @current_user.friends_to_user_ids + [@current_user.id]
    ids.uniq
  end
end
