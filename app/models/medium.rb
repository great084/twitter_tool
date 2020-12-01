class Medium < ApplicationRecord
  belongs_to :tweet
  validates :media_url, presence: true
end
