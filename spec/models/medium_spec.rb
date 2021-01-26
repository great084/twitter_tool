require "rails_helper"

RSpec.describe Medium, type: :model do
  before :each do
    @medium = FactoryBot.create(:medium)
    @tweet = Tweet.find(@medium.tweet_id)
  end

  context "association check in create record" do
    it "is valid when tweet record is valid" do
      expect(@medium).to be_valid
    end

    it "is invalid when tweet record is invalid" do
      @tweet.destroy
      @invalid_medium = Medium.create(tweet_id: @tweet.id, media_url: "string")
      expect(@invalid_medium).to be_invalid
    end
  end

  context "association check when destroy tweet record" do
    it "is not be present" do
      @tweet.destroy
      @after_medium = Medium.find_by(id: @medium.tweet_id)
      expect(@after_medium).to_not be_present
    end
  end

  context "without a any parameter" do
    it "is invalid without a tweet_id" do
      @medium.update(tweet_id: nil)
      @medium.valid?
      expect(@medium.errors[:tweet]).to include("を入力してください")
    end

    it "is invalid without a meia_url" do
      @medium.update(media_url: nil)
      @medium.valid?
      expect(@medium.errors[:media_url]).to include("を入力してください")
    end
  end
end
