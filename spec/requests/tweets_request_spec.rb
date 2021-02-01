require "rails_helper"

RSpec.describe "Tweets", type: :request do
  before :each do
    @tweet = FactoryBot.create(:tweet)
    @user = User.find(@tweet.user_id)
  end

  describe "GET #index" do
    context "ログインしていない場合" do
      it "リクエストとは別のページにリダイレクトされること" do
        get root_path
        expect(response).to have_http_status(302)
      end

      it "users/indexテンプレートが表示されること" do
        get root_path
        expect(response.body).to include("http://www.example.com/users")
      end
    end

    context "ユーザがログインしている場合" do
      let(:rspec_session) { { uid: 123_456 } } # ログイン処理

      it "リクエストが成功すること" do
        get root_path
        expect(response).to have_http_status(200)
      end

      it "indexテンプレートが表示されること" do
        get root_path
        # タイムラインが存在すること
        expect(response.body).to include("タイムライン")
      end
    end
  end

  describe "GET #new" do
    context "ログインしていない場合" do
      it "リクエストとは別のページにリダイレクトされること" do
        get new_tweet_path
        expect(response).to have_http_status(302)
      end

      it "users/indexテンプレートが表示されること" do
        get new_tweet_path
        expect(response.body).to include("http://www.example.com/users")
      end
    end

    context "ユーザがログインしている場合" do
      let(:rspec_session) { { uid: 123_456 } } # ログイン処理

      it "リクエストが成功すること" do
        get new_tweet_path
        expect(response).to have_http_status(200)
      end

      it "newテンプレートが表示されること" do
        get new_tweet_path
        # "取得する" ボタンがあること
        expect(response.body).to include("取得する")
      end
    end
  end

  describe "POST #show" do
    context "ログインしていない場合" do
      it "リクエストとは別のページにリダイレクトされること" do
        get tweet_path(@tweet)
        expect(response).to have_http_status(302)
      end

      it "users/indexテンプレートが表示されること" do
        get tweet_path(@tweet)
        expect(response.body).to include("http://www.example.com/users")
      end
    end

    context "ツイート所持ユーザがログインしている場合" do
      let(:rspec_session) { { uid: 123_456 } } # ログイン処理

      it "リクエストが成功すること" do
        get tweet_path(@tweet)
        expect(response).to have_http_status(200)
      end

      it "showテンプレートが表示されること" do
        get tweet_path(@tweet)
        # "再投稿する", "リツイートする" ボタンがあること
        expect(response.body).to include("再投稿する", "リツイートする")
      end
    end

    context "ツイート所持ユーザとは他のユーザがログインした場合" do
      let!(:else_user) { FactoryBot.create(:user).update(uid: "else_user") }
      let(:rspec_session) { { uid: "else_user" } } # ログイン処理

      it "リクエストとは別のページにリダイレクトされること" do
        get tweet_path(@tweet)
        expect(response).to have_http_status(302)
      end

      it "users/indexテンプレートが表示されること" do
        get tweet_path(@tweet)
        expect(response.body).to include("http://www.example.com/users")
      end
    end
  end
end
