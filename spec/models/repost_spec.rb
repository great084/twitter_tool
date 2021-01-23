require "rails_helper"

RSpec.describe Repost, type: :model do
  before :each do
    @tweet = FactoryBot.create(:tweet)
  end

  context "association check in create record" do
    it "is valid when tweet record is valid" do
      @repost = Repost.create(tweet_id: @tweet.id)
      expect(@repost).to be_valid
    end

    it "is invalid when tweet record is invalid" do
      @tweet.destroy
      @repost = Repost.create(tweet_id: @tweet.id)
      expect(@repost).to_not be_valid
    end
  end

  context "association check when destroy tweet record" do
    it "is not present" do
      @before_repost = Repost.create(tweet_id: @tweet.id)
      @tweet.destroy
      @after_repost = Repost.find_by(id: @before_repost.id)
      expect(@after_repost).to_not be_present
    end
  end
end
