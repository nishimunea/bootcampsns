class Friend < ActiveRecord::Base
  belongs_to :from_user, :class_name => 'User'
  belongs_to :to_user, :class_name => 'User'

  validates :from_user, presence: true 
  validates :to_user, presence: true
  before_save :verify_valid_user

  private

  def verify_valid_user
    errors.add(:base, '自分自身のログインIDは指定できません') if self.from_user_id == self.to_user_id
    errors.add(:base, '指定されたユーザは既に登録済みです') unless Friend.find_by(from_user_id: self.from_user_id, to_user_id: self.to_user_id).nil?
    return false if errors.any?
  end

end
