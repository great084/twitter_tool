class User < ApplicationRecord
   validates :uid, presence: true
   validates :nickname, presence: true
end
