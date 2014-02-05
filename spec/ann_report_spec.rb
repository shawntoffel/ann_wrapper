require 'spec_helper'

shared_examples_for "a String" do |method, expected|
	it "containing the correct #{method}" do
		report = ANN_Wrapper.fetch_titles("anime", 0, 5)[0]
		result = report.send(:"#{method}")
		expect(result).to be_an_instance_of String
		expect(result).to eql expected
	end
end

describe ANN_Report do
	describe "#id" do 
		it_returns "a String", :id, "15847"
	end

	describe "#type" do
		it_returns "a String", :type, "TV"
	end

	describe "#name" do
		it_returns "a String", :name, "Nandaka Velonica"
	end

	describe "#precision" do
		it_returns "a String", :precision, "TV"
	end

	describe "#vintage" do
		it_returns "a String", :vintage, "2014-03-10 to 2014-03-21"
	end
end
