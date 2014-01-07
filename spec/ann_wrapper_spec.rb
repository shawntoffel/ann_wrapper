require 'spec_helper'

describe "fetch_ann_anime" do

	context "a valid id is provided" do
		it "should return data for an ann anime" do
			anime = ANN_Wrapper.instance.fetch_ann_anime(11770)
			anime.should_not be_nil
			anime.title.first.should eql "Steins;Gate"
		end
	end

	context "an invalid id is provided" do
		it "should return an ANN_Error" do
			anime = ANN_Wrapper.instance.fetch_ann_anime(117700)
			anime.should_not be_nil
			anime.should be_kind_of(ANN_Error)
			anime.message.should_not be_nil
		end
	end

end
