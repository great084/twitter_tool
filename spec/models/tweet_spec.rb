require "rails_helper"

RSpec.describe Tweet, type: :model do
  before :each do
    @tweet = FactoryBot.create(:tweet)
  end

  context "validation for tweet_flag boolean" do
    it { is_expected.to allow_value(true).for(:tweet_flag) }
    it { is_expected.to allow_value(false).for(:tweet_flag) }
    it { is_expected.not_to allow_value(nil).for(:tweet_flag) }
  end

  context "validation for retweet_flag boolean" do
    it { is_expected.to allow_value(true).for(:retweet_flag) }
    it { is_expected.to allow_value(false).for(:retweet_flag) }
    it { is_expected.not_to allow_value(nil).for(:retweet_flag) }
  end

  context "with correct parameters" do
    it "is valid" do
      expect(@tweet).to be_valid
    end
  end

  context "without a any parameter" do
    it "is invalid without a tweet_created_at" do
      @tweet.update(tweet_created_at: nil)
      @tweet.valid?
      expect(@tweet.errors[:tweet_created_at]).to_not include("can't be blank")
    end

    it "is invalid without a tweet_string_id" do
      @tweet.update(tweet_string_id: nil)
      @tweet.valid?
      expect(@tweet.errors[:tweet_string_id]).to_not include("cant be blank")
    end

    it "is invalid without a text" do
      @tweet.update(text: nil)
      @tweet.valid?
      expect(@tweet.errors[:text]).to_not include("can't be blank")
    end

    it "is invalid without a retweet_count" do
      @tweet.update(retweet_count: nil)
      @tweet.valid?
      expect(@tweet.errors[:retweet_count]).to_not include("can't be blank")
    end

    it "is invalid without a favorite_count" do
      @tweet.update(favorite_count: nil)
      @tweet.valid?
      expect(@tweet.errors[:favorite_count]).to_not include("can't be blank")
    end

    it "is invalid without a tweet_flag" do
      @tweet.update(tweet_flag: nil)
      @tweet.valid?
      expect(@tweet.errors[:tweet_flag]).to_not include("can't be blank")
    end

    it "is invalid without a retweet_flag" do
      @tweet.update(retweet_flag: nil)
      @tweet.valid?
      expect(@tweet.errors[:retweet_flag]).to_not include("can't be blank")
    end
  end
end
