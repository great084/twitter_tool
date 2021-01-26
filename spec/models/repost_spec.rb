require "rails_helper"

RSpec.describe Repost, type: :model do
  before :each do
    @repost = FactoryBot.create(:repost)
    @tweet = Tweet.find(@repost.tweet_id)
  end

  context "association check in create record" do
    it "is valid when tweet record is valid" do
      expect(@repost).to be_valid
    end

    it "is invalid when tweet record is invalid" do
      @tweet.destroy
      @invalid_repost = Repost.create(tweet_id: @tweet.id)
      expect(@invalid_repost).to be_invalid
    end
  end

  context "association check when destroy tweet record" do
    it "is not present" do
      @tweet.destroy
      @after_repost = Repost.find_by(id: @repost.id)
      expect(@after_repost).to_not be_present
    end
  end

  context "without a any parameter" do
    it "is invalid without a tweet_id" do
      @repost.update(tweet_id: nil)
      @repost.valid?
      expect(@repost.errors[:tweet]).to include("を入力してください")
    end
  end
end
