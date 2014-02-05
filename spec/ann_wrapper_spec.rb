require 'spec_helper'

describe ANN_Wrapper do

	describe "#fetch_anime" do

		context "valid id is provided" do
			it "returns an ANN_Anime object" do
				anime = ANN_Wrapper.fetch_anime 11770
				expect(anime).to be_an_instance_of ANN_Anime
			end
		end

		context "an invalid id is provided" do
			it "returns an ANN_Error object" do
				anime = ANN_Wrapper.fetch_anime 117700
				expect(anime).to be_an_instance_of ANN_Error
			end
		end
	end

	describe "#fetch_titles" do
		context "valid parameters privided" do
			it "returns Array of ANN_Reports" do
				reports = ANN_Wrapper.fetch_titles
				expect(reports).to be_an_instance_of Array
				reports.each do |r|
					expect(r).to be_an_instance_of (ANN_Report)
				end
			end
		end
	end
end
