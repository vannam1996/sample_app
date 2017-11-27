class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.max_content}
  validate :picture_size

  scope :feed_user, ->(id){where user_id: id}
  scope :order_by_date, ->{order(created_at: :desc)}
  scope :feed_for_home, ->(user_id, following_ids){where(user_id: [user_id, *following_ids])}

  private

  def picture_size
    return unless picture.size > Settings.micropost.size_file.megabytes
    errors.add :picture, t("micropost.flash.err_addfile")
  end
end
