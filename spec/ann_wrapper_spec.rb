require 'spec_helper'

describe ANN_Wrapper do

	describe "#fetch_anime" do
		context "when a valid id is provided" do
			it "returns an ANN_Anime object" do
				anime = ANN_Wrapper.fetch_anime 11770
				expect(anime).to be_an_instance_of ANN_Anime
			end
		end

		context "when an invalid id is provided" do
			it "returns an ANN_Error object" do
				anime = ANN_Wrapper.fetch_anime 117700
				expect(anime).to be_an_instance_of ANN_Error
			end
		end

		context "when an invalid url is provided" do
			let(:anime) {ANN_Wrapper.fetch_anime 11770, "/invalid_url"}
			it "returns an ANN_Error object" do
				expect(anime).to be_an_instance_of ANN_Error
			end
			it "includes a message stating the URL was not valid" do
				expect(anime.message).to eql "Could not reach valid URL"
			end
		end

		context "when an invalid warning comes back" do
			let(:anime) {ANN_Wrapper.fetch_anime 46580}
			it "returns an ANN_Error object" do
				expect(anime).to be_an_instance_of ANN_Error
			end
			it "includes a message stating the response is not recognized" do
				expect(anime.message).to eql "unrecognized response body"
			end
		end
	end

	describe "#fetch_manga" do
		context "when a valid id is provided" do
			it "returns an ANN_Manga object" do
				manga = ANN_Wrapper.fetch_manga 16086
				expect(manga).to be_an_instance_of ANN_Manga
			end
		end

		context "when an invalid id is provided" do
			it "returns an ANN_Error object" do
				manga = ANN_Wrapper.fetch_manga 160860
				expect(manga).to be_an_instance_of ANN_Error
			end
		end

		context "when an invalid url is provided" do
			let(:manga) {ANN_Wrapper.fetch_manga 16086, "/invalid_url"}
			it "returns an ANN_Error object" do
				expect(manga).to be_an_instance_of ANN_Error
			end
			it "includes a message stating the URL was not valid" do
				expect(manga.message).to eql "Could not reach valid URL"
			end
		end

		context "when an invalid warning comes back" do
			let(:manga) {ANN_Wrapper.fetch_manga 46580}
			it "returns an ANN_Error object" do
				expect(manga).to be_an_instance_of ANN_Error
			end
			it "includes a message stating the response is not recognized" do
				expect(manga.message).to eql "unrecognized response body"
			end
		end
	end

	describe "#batch_anime" do
		context "when valid ids are provided" do
			it "returns an Array of ANN_Anime object" do
				anime = ANN_Wrapper.batch_anime [11770,12120,15336]
				expect(anime).to be_an_instance_of Array
				expect(anime.first).to be_an_instance_of ANN_Anime
			end
		end

		context "when both valid and invalid ids are provided" do
			it "returns an Array containing an ANN_Anime and ANN_Error objects" do
				anime = ANN_Wrapper.batch_anime [11770, 121200]
				expect(anime).to be_an_instance_of Array
				expect(anime.first).to be_an_instance_of ANN_Anime
				expect(anime.last).to be_an_instance_of ANN_Error
			end
		end

		context "when an invalid url is provided" do
			let(:anime) {ANN_Wrapper.batch_anime [11770], "/invalid_url"}
			it "returns an Array of ANN_Error object" do
				expect(anime).to be_an_instance_of Array
				expect(anime.first).to be_an_instance_of ANN_Error
			end
			it "includes a message stating the URL was not valid" do
				expect(anime.first.message).to eql "Could not reach valid URL"
			end
		end
	end

	describe "#batch_manga" do
		context "when valid ids are provided" do
			it "returns an Array of ANN_Anime object" do
				manga = ANN_Wrapper.batch_manga [16086,4199,11608]
				expect(manga).to be_an_instance_of Array
				expect(manga.first).to be_an_instance_of ANN_Manga
			end
		end

		context "when both valid and invalid ids are provided" do
			it "returns an Array containing an ANN_Anime and ANN_Error objects" do
				manga = ANN_Wrapper.batch_manga [16086, 121200]
				expect(manga).to be_an_instance_of Array
				expect(manga.first).to be_an_instance_of ANN_Manga
				expect(manga.last).to be_an_instance_of ANN_Error
			end
		end

		context "when an invalid url is provided" do
			let(:manga) {ANN_Wrapper.batch_manga [16086], "/invalid_url"}
			it "returns an Array of ANN_Error object" do
				expect(manga).to be_an_instance_of Array
				expect(manga.first).to be_an_instance_of ANN_Error
			end
			it "includes a message stating the URL was not valid" do
				expect(manga.first.message).to eql "Could not reach valid URL"
			end
		end
	end
	describe "#fetch_titles" do
		context "when valid parameters are privided" do
			it "returns Array of ANN_Reports" do
				reports = ANN_Wrapper.fetch_titles
				expect(reports).to be_an_instance_of Array
				reports.each do |r|
					expect(r).to be_an_instance_of ANN_Report
				end
			end
		end

		context "when invalid parameters are privided" do
			it "returns  of ANN_Reports" do
				reports = ANN_Wrapper.fetch_titles({type: "anime", nskip: 0, nlist: 5, name: "", api_url: "/invalid_url"})
				expect(reports).to be_an_instance_of ANN_Error
			end
		end
	end
end
