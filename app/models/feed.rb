class Feed < ActiveRecord::Base
  belongs_to :user
  before_save :verify_valid_feed
  validates :feed_type, presence: true
  validates :user_id, presence: true
  validates :comment, length: { maximum: 140 }

  private

  def verify_valid_feed
    errors.add(:base, 'フィード種別が不正です') unless self.feed_type.in? %w( text image )
    errors.add(:base, 'テキストが入力されていません') if self.feed_type == 'text' and self.comment.blank?
    errors.add(:base, '画像が指定されていません') if self.feed_type == 'image' and self.image_file_name.blank?
    return false if errors.any?
  end

end
