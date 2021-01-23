require "rails_helper"

RSpec.describe Retweet, type: :model do
  before :each do
    @tweet = FactoryBot.create(:tweet)
  end

  context "association check in create record" do
    it "is valid when tweet record is valid" do
      @retweet = Retweet.create(tweet_id: @tweet.id)
      expect(@retweet).to be_valid
    end

    it "is invalid when tweet record is invalid" do
      @tweet.destroy
      @retweet = Retweet.create(tweet_id: @tweet.id)
      expect(@retweet).to_not be_valid
    end
  end

  context "association check when destroy tweet record" do
    it "is not present" do
      @before_retweet = Retweet.create(tweet_id: @tweet.id)
      @tweet.destroy
      @after_retweet = Retweet.find_by(id: @before_retweet.id)
      expect(@after_retweet).to_not be_present
    end
  end
end