require "rails_helper"

RSpec.describe Medium, type: :model do
  before :each do
    @tweet = FactoryBot.create(:tweet)
  end
  let(:medium) { Medium.new(media_url: "string") }

  context "association check in create record" do
    it "is valid when tweet record is valid" do
      medium.update(tweet_id: @tweet.id)
      expect(medium).to be_valid
    end

    it "is invalid when tweet record is invalid" do
      @tweet.destroy
      medium.update(tweet_id: @tweet.id)
      expect(medium).to_not be_valid
    end
  end

  context "association check when destroy tweet record" do
    it "is not be present" do
      medium.update(tweet_id: @tweet.id)
      @tweet.destroy
      @after_medium = Medium.find_by(id: medium.id)
      expect(@after_medium).to_not be_present
    end
  end

  context "without a any parameter" do
    it "is invalid without a tweet_id" do
      medium.update(tweet_id: nil)
      medium.valid?
      expect(medium.errors[:tweet_id]).to_not include("can't be blank")
    end

    it "is invalid without a meia_url" do
      @medium = Medium.create(tweet_id: @tweet.id, media_url: nil)
      @medium.valid?
      expect(@medium.errors[:media_url]).to_not include("can't be blank")
    end
  end
end
