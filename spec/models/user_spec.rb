require "rails_helper"

RSpec.describe User, type: :model do
  before :each do
    @user = FactoryBot.create(:user)
  end

  describe "バリテーション" do
    context "データが条件を満たすとき" do
      it "保存できる" do
        expect(@user).to be_valid
      end
    end
    context "uidが空の時" do
      it "エラーが発生する" do
        @user.update(uid: nil)
        expect(@user).to be_invalid
        expect(@user.errors[:uid]).to include("を入力してください")
      end
    end
    context "nicknameが空の時" do
      it "エラーが発生する" do
        @user.update(nickname: nil)
        expect(@user).to be_invalid
        expect(@user.errors[:nickname]).to include("を入力してください")
      end
    end
    context "tokenが空の時" do
      it "エラーが発生する" do
        @user.update(token: nil)
        expect(@user).to be_invalid
        expect(@user.errors[:token]).to include("を入力してください")
      end
    end
    context "secretが空の時" do
      it "エラーが発生する" do
        @user.update(secret: nil)
        expect(@user).to be_invalid
        expect(@user.errors[:secret]).to include("を入力してください")
      end
    end
  end

  describe "アソシエーション" do
    context "ユーザーインスタンスを削除する" do
      it "そのユーザーのツイートインスタンスは存在しない" do
        @user.destroy
        @after_tweet = Tweet.find_by(user_id: @user.id)
        expect(@after_tweet).to be_nil
      end
    end
    context "ユーザーインスタンスを作成する" do
      it "そのユーザーのtweetインスタンスを作成できる" do
        @tweet = FactoryBot.create(:tweet, user_id: @user.id)
        expect(@tweet).to be_valid
      end
    end
  end
end
