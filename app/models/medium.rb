class Medium < ApplicationRecord
  belongs_to :tweet
  validates :media_url, presence: true
  mount_uploader :media_url, ImageUploader
end
