
require 'spec_helper'



describe ANN_Anime do

	shared_examples_for "an Array of" do |method, object, expected, index=0|
		let(:result) {ANN_Wrapper.fetch_anime(11770).send(method.to_sym)}
		it "#{object} objects" do
			expect(result).to be_an_instance_of Array
			expect(result.first).to be_an_instance_of object
		end
		it "containing the correct #{method}" do
			expect(result[index]).to eql expected
		end
	end

	shared_examples_for "a String" do |method, expected|
		it "containing the correct #{method}" do
			anime = ANN_Wrapper.fetch_anime 11770
			result = anime.send(:"#{method}")
			expect(result).to be_an_instance_of String
			expect(result).to eql expected
		end
	end

	shared_examples_for "a Hash of" do |method, object, key, expected|
		let(:result) {ANN_Wrapper.fetch_anime(11770).send(method.to_sym)}
		it "#{object}s" do
			expect(result).to be_an_instance_of Hash
			expect(result.first).to be_an_instance_of object
		end
		it "containing the correct #{method}" do
			expect(result[key].first).to eql expected
		end
	end

	describe "#find_info" do
		let(:anime) {ANN_Wrapper.fetch_anime(11770)}
		context "invalid key" do
			it "returns an empty array" do
				expect(anime.find_info("DOES NOT EXIST").size).to eql 0
			end
		end
	end

	describe "#id" do
		it_returns "a String", :id, "11770"
	end

	describe "#title" do
		it_returns "an Array of", :title, String, "Steins;Gate"
	end

	describe "#alt_titles" do
		it_returns "a Hash of", :alt_titles, Array, "PT", "Steins-Gate e a Teoria do Caos"
	end

	describe "#synopsis" do
		it_returns "an Array of", :synopsis, String, "Rintaro Okabe is a self-proclaimed \"mad scientist\" who believes that an international organization is conspiring to reshape the world according to its own interests. He and his friend Itaru Hashida inadvertently create a gadget able to send messages to the past. The discovery and experimentation of this instrument become the catalyst of fundamental alterations to the present. Oblivious of the consequences of their actions, Rintaro and his friends end up creating modifications of grievous proportions. He must then try to find a way to return as close as possible to the original timeline in order to save his precious lab members."
	end

	describe "#num_episodes" do
		it_returns "an Array of", :num_episodes, String, "24"
	end

	describe "#vintage" do
		it_returns "an Array of", :vintage, String, "2011-04-03 (Advanced screening)"
	end

	describe "#genres" do
		it_returns "an Array of", :genres, String, "adventure"
	end

	describe "#themes" do
		it_returns "an Array of", :themes, String, "butterfly effect"
	end

	describe "#op_theme" do
		it_returns "an Array of", :op_theme, String, "\"Hacking to the Gate\" by Kanako Ito"
	end

	describe "#ed_theme" do
		it_returns "an Array of", :ed_theme, String, "#3: \"Another Heaven\" by Kanako Itou (ep 24)", 2
	end

	describe "#ratings" do
		it_returns "an Array of", :ratings, ANN_Rating, ANN_Rating.new("3788", "9.1129", "9.1075")
	end

	describe "#episodes" do
		it_returns "an Array of", :episodes, ANN_Episode, ANN_Episode.new("1", "Prologue of the Beginning and End", "EN")
	end

	describe "#cast" do
		it_returns "an Array of", :cast, ANN_Cast, ANN_Cast.new("110469", "Rintarō Okabe", "Peter Lehn", "DE")
	end

	describe "#staff" do
		it_returns "an Array of", :staff, ANN_Staff, ANN_Staff.new("9693", "Director", "Hiroshi Hamasaki"), 1
	end

	describe "#images" do
		it_returns "an Array of", :images, ANN_Image, ANN_Image.new("http://cdn.animenewsnetwork.com/thumbnails/hotlink-fit200x200/encyc/A11770-1864351140.1370764886.jpg", "200", "125")
	end

	describe "#to_h" do
		let(:anime) {ANN_Wrapper.fetch_anime(11770)}
		it "returns a hash of anime information" do
			anime_hash = anime.to_h
			expect(anime_hash).to be_instance_of Hash
			expect(anime_hash[:id]).to eql "11770"
		end
		it "correctly converts structs to hash" do
			anime_hash = anime.to_h
			staff_hash = ANN_Staff.new("9693", "Director", "Hiroshi Hamasaki").hash
			expect(anime_hash[:staff][1]).to eql staff_hash
		end
	end
end

