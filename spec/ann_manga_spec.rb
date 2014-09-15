require 'spec_helper'

shared_examples_for "an Array of" do |method, object, expected, index=0|
  let(:result) {ANN_Wrapper.fetch_manga(16086).send(method.to_sym)}
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
    manga = ANN_Wrapper.fetch_manga 16086
    result = manga.send(:"#{method}")
    expect(result).to be_an_instance_of String
    expect(result).to eql expected
  end
end

shared_examples_for "a Hash of" do |method, object, key, expected|
  let(:result) {ANN_Wrapper.fetch_manga(16086).send(method.to_sym)}
  it "#{object}s" do
    expect(result).to be_an_instance_of Hash
    expect(result.first).to be_an_instance_of object
  end
  it "containing the correct #{method}" do
    expect(result[key].first).to eql expected
  end
end


describe ANN_Manga do

  describe "#find_info" do
    let(:manga) {ANN_Wrapper.fetch_manga(16086)}
    context "invalid key" do
      it "returns an empty array" do
        expect(manga.find_info("DOES NOT EXIST").size).to eql 0
      end
    end
  end

  describe "#id" do
    it_returns "a String", :id, "16086"
  end

  describe "#title" do
    it_returns "an Array of", :title, String, "Tokyo Ghoul"
  end

  describe "#alt_titles" do
    it_returns "a Hash of", :alt_titles, Array, "PT", "Tokyo Ghoul"
  end

  describe "#synopsis" do
    it_returns "an Array of", :synopsis, String, "Ken Kaneki is a bookworm college student who meets a girl named Rize at a cafe he frequents. They're the same age and have the same interests, so they quickly become close. Little does Kaneki know that Rize is a ghoul - a kind of monster that lives by hunting and devouring human flesh. When part of her special organ - \"the red child\" - is transplanted into Kaneki, he becomes a ghoul himself, trapped in a warped world where humans are not the top of the food chain."

  end

  describe "#vintage" do
    it_returns "an Array of", :vintage, String, "2011-09-08 (serialized in Weekly Young Jump)"
  end

  describe "#number_of_tankoubon" do
    it_returns "an Array of", :number_of_tankoubon, String, "9"
  end

  describe "#genres" do
    it_returns "an Array of", :genres, String, "horror"
  end

  describe "#themes" do
    it_returns "an Array of", :themes, String, "monsters"
  end

  describe "#staff" do
    it_returns "an Array of", :staff, ANN_Staff, ANN_Staff.new("123563", "Story and Art", "Sui Ishida")
  end

  describe "#images" do
    it_returns "an Array of", :images, ANN_Image, ANN_Image.new("http://cdn.animenewsnetwork.com/thumbnails/hotlink-fit200x200/encyc/A16086-3098213756.1401567064.jpg", "141", "200")
  end

  describe "#to_h" do
    let(:manga) {ANN_Wrapper.fetch_manga(16086)}
    it "returns a hash of manga information" do
      manga_hash = manga.to_h
      expect(manga_hash).to be_instance_of Hash
      expect(manga_hash[:id]).to eql "16086"
    end
    it "correctly converts structs to hash" do
      manga_hash = manga.to_h
      staff_hash = ANN_Staff.new("123563", "Story and Art", "Sui Ishida").hash
      expect(manga_hash[:staff][0]).to eql staff_hash
    end
  end
end

