class IconsController < ApplicationController

  def create
    file_name = params[:image].original_filename.downcase
    mime_type = params[:image].content_type.downcase
    if !!file_name.match(/png|jpeg|jpg|gif/) and mime_type.start_with? 'image/'
      image_path = "#{Rails.root}/public/icons/#{file_name}"
      FileUtils.mv params[:image].tempfile, image_path
      FileUtils.chmod 0644, image_path
      if px = params[:resize_max_pixel]
        `convert -resize #{px}x#{px} #{image_path} #{image_path}` # ImageMagickで画像をリサイズ
      end
      render json: {file_name: file_name} and return
    else
      render json: {errors: ['画像のアップロードに失敗しました']}, status: :bad_request and return
    end
  end
end
