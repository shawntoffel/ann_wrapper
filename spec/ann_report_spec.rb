# clear global definitions

require 'spec_helper'


describe ANN_Report do
	shared_examples_for "a String" do |method, expected|
		it "containing the correct #{method}" do
			report = ANN_Wrapper.fetch_titles({type: "anime", nskip: 0, nlist: 5})[0]
			result = report.send(:"#{method}")
			expect(result).to be_an_instance_of String
			expect(result).to eql expected
		end
	end

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

	describe "get_info_on" do
		let(:report) {ANN_Wrapper.fetch_titles({type: "anime", nskip: 0, nlist: 5})[0]}
		context "when a valid info key is provided" do
			it "returns the correct value for the key" do
				result = report.get_info_on("id")
				expect(result).to be_an_instance_of String
				expect(result).to eql "15847"
			end
		end

		context "when an invalid info key is provided" do
			it "returns nil" do
				result = report.get_info_on("INVALID")
				expect(result).to be nil
			end
		end
	end

	describe "#to_h" do
		let(:report) {ANN_Wrapper.fetch_titles({type: "anime", nskip: 0, nlist: 5})[0]}
		it "returns a hash of report information" do
			report_hash = report.to_h
			expect(report_hash).to be_instance_of Hash
			expect(report_hash[:id]).to eql "15847"
		end
	end
end
