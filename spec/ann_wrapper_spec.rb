require 'spec_helper'

describe ANN_Wrapper do

	describe "#fetch_anime" do
		context "valid id is provided" do
			it "returns an ANN_Anime object" do
				anime = ANN_Wrapper.fetch_anime(11770)
				anime.should be_an_instance_of ANN_Anime
			end
		end

		context "an invalid id is provided" do
			it "returns an ANN_Error object" do
				anime = ANN_Wrapper.fetch_anime(117700)
				anime.should be_an_instance_of ANN_Error
			end
		end
	end

	describe "#fetch_titles" do
		context "valid parameters privided" do
			it "returns Array of ANN_Reports" do
				reports = ANN_Wrapper.fetch_titles
				reports.should be_an_instance_of Array
				reports.each do |r|
					r.should be_an_instance_of (ANN_Report)
				end
			end
		end

		context "invalid parameters provided" do
			it "returns an empty Array" do
				anime = ANN_Wrapper.fetch_titles 34
				anime.should be_an_instance_of Array
				anime.size.should == 0
			end
		end
	end
end
