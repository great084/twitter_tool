require "rails_helper"

RSpec.describe "Users", type: :system do
  before do
    # @user = User.create(uid: "123456", nickname: "hogehoge")
    OmniAuth.config.mock_auth[:twitter] = nil
  end

  context "Twitter認証ができるとき" do
    it "初めてログインするユーザーがTwitter認証を許可した時" do
      Rails.application.env_config["omniauth.auth"] = twitter_mock_uid_234567
      visit root_path
      expect(page).to_not have_content("ログアウト") # ログイン前はログアウトという表示が無い
      find_link("ログイン", href: "/auth/twitter").click # ログインボタンをクリックしてTwitter認証を行う
      expect(page).to have_content("ログアウト") # リダイレクトされてTOPに戻るとログインできている
    end

    it "過去にログイン済みのユーザーがTwitter認証を許可した時" do
      Rails.application.env_config["omniauth.auth"] = twitter_mock_uid_123456
      visit root_path
      expect(page).to_not have_content("ログアウト") # ログイン前はログアウトという表示が無い
      find_link("ログイン", href: "/auth/twitter").click # ログインボタンをクリックしてTwitter認証を行う
      expect(page).to have_content("ログアウト") # リダイレクトされてTOPに戻るとログインできている
    end
  end

  context "Twitter認証をしたが、返り値が異常な場合" do
    it "ユーザーがTwitter認証を許可したが、twitterからの返り値が異常な時" do
      Rails.application.env_config["omniauth.auth"] = twitter_invalid_mock
      visit root_path
      expect(page).to_not have_content("ログアウト")
      find_link("ログイン", href: "/auth/twitter").click
      expect(page).to_not have_content("ログアウト") # リダイレクトされてTOPに戻るとログインできてない
      expect(page).to have_content("ログインできませんでした。") # ログインできなかった旨のメッセージが出力される
    end
  end

  context "Twitter認証をキャンセルしたとき" do
    it "ユーザーがTwitter認証をキャンセルした時" do
      Rails.application.env_config["omniauth.auth"] = twitter_cancel_mock
      visit root_path
      expect(page).to_not have_content("ログアウト") # ログイン前はマイページという表示が無い
      find_link("ログイン", href: "/auth/twitter").click # ログインボタンをクリックしてTwitter認証を行う
      expect(page).to_not have_content("ログアウト") # リダイレクトされてTOPに戻るとログインできてない
      expect(page).to have_content("ログインをキャンセルしました。") # ログインをキャンセルした旨のメッセージが出力される
    end
  end
end

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
        @tweet = FactoryBot.create(:tweet,user_id: @user.id)
        expect(@tweet).to be_valid 
     end 
    end
  end
end
