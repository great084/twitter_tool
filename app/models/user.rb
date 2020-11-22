class User < ApplicationRecord
   validates :uid, presence: true
   validates :nickname, presence: true
   has_many :tweets, dependent: :destroy

   def self.find_or_create_from_auth_hash(auth_hash)
      uid = auth_hash[:uid]
      nickname = auth_hash[:info][:nickname]
      # find_or_create_by()は()の中の条件のものが見つければ取得し、なければ新しく作成するというメソッド
      find_or_create_by(uid: uid) do |user|
        user.uid = uid
        user.nickname = nickname
      end
    end
end
