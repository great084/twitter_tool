require "rails_helper"

RSpec.describe Retweet, type: :model do
  before :each do
    @retweet = FactoryBot.create(:retweet)
    @tweet = Tweet.find(@retweet.tweet_id)
  end

  context "association check in create record" do
    it "is valid when tweet record is valid" do
      expect(@retweet).to be_valid
    end

    it "is invalid when tweet record is invalid" do
      @tweet.destroy
      @invalid_retweet = Retweet.create(tweet_id: @tweet.id)
      expect(@invalid_retweet).to be_invalid
    end
  end

  context "association check when destroy tweet record" do
    it "is not present" do
      @tweet.destroy
      @after_retweet = Retweet.find_by(tweet_id: @tweet.id)
      expect(@after_retweet).to_not be_present
    end
  end

  context "without any parameter" do
    it"is invalid without a tweet_id" do
      @retweet.update(tweet_id: nil)
      @retweet.valid?
      expect(@retweet.errors[:tweet]).to include("を入力してください")
    end
  end
end
