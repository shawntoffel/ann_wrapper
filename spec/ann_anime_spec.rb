require 'spec_helper'

describe ANN_Anime do

	def array_of_strings(input)
		expect(input).to be_instance_of Array
		expect(input[0]).to be_instance_of String
	end

	before(:each) do
		@anime = ANN_Wrapper.fetch_anime(11770)
	end

	describe "#id" do
		it "returns a string containing the anime id" do
			expect(@anime.id).to be_instance_of String
			expect(@anime.id).to eql "11770"
		end
	end

	describe "#title" do
		it "returns an array containing string title" do
			array_of_strings(@anime.title)
			expect(@anime.title[0]).to eql "Steins;Gate"
		end
	end

	describe "#alt_titles" do
		it "returns a hash of alternate titles" do
			expect(@anime.alt_titles).to be_instance_of Hash
			array_of_strings(@anime.alt_titles["JA"])
			expect(@anime.alt_titles["JA"][0]).to eql "シュタインズ・ゲート"
		end
	end

	describe "#synopsis" do
		it "returns an Array containing a synopsis string" do
			array_of_strings @anime.synopsis
			expect(@anime.synopsis[0]).to include "Rintaro Okabe is a self-proclaimed"
		end
	end

	describe "#num_episodes" do
		it "returns an Array containing a string of the number of episodes" do
			array_of_strings @anime.num_episodes
			expect(@anime.num_episodes).to eql ["24"]
		end
	end

	describe "#vintage" do
		it "returns an Array containing vintage strings" do
			array_of_strings @anime.vintage
			expect(@anime.vintage[0]).to eql "2011-04-03 (Advanced screening)"
		end
	end

	describe "#genres" do
		it "returns an Array containing genre strings" do
			array_of_strings @anime.genres
			expect(@anime.genres[0]).to eql "adventure"
		end
	end

	describe "#themes" do
		it "returns an Array containing theme strings" do
			array_of_strings @anime.themes
			expect(@anime.themes[0]).to eql "butterfly effect"
		end
	end

	describe "#op_theme" do
		it "returns an Array containing op_theme strings" do
			array_of_strings @anime.op_theme
			expect(@anime.op_theme[0]).to eql "\"Hacking to the Gate\" by Kanako Ito"
		end
	end

	describe "#ed_theme" do
		it "returns an Array containing ed_theme strings" do
			array_of_strings @anime.ed_theme
			expect(@anime.ed_theme[0]).to eql "\"Tokitsukasadoru Jūni no Meiyaku\" (刻司ル十二ノ盟約) by Yui Sakakibara"
		end
	end

	describe "#cast" do
		it "returns an Array containing ANN_Cast" do
			expect(@anime.cast).to be_instance_of Array
			expect(@anime.cast[0]).to be_instance_of ANN_Cast
			first_cast = ANN_Cast.new("1386", "Yugo \"Braun\" Tennoji", "Christopher R. Sabat", "EN")
			expect(@anime.cast[0]).to eql first_cast
		end
	end

	describe "#staff" do
		it "returns an Array containing ANN_Staff" do
			expect(@anime.staff).to be_instance_of Array
			expect(@anime.staff[0]).to be_instance_of ANN_Staff
			first_staff = ANN_Staff.new("593", "Director", "Takuya Satō")
			expect(@anime.staff[0]).to eql first_staff
		end
	end

	describe "#images" do
		it "returns an Array containing ANN_Image" do
			expect(@anime.images).to be_instance_of Array
			expect(@anime.images[0]).to be_instance_of ANN_Image
			first_image = ANN_Image.new("http://cdn.animenewsnetwork.com/thumbnails/fit200x200/encyc/A11770-1864351140.1370764886.jpg", "200", "125")
			expect(@anime.images[0]).to eql first_image
		end
	end
end
		
