require 'sinatra/base'

class FakeANN < Sinatra::Base
	get '/encyclopedia/api.xml' do
		case params[:title]
		when "11770"
			xml_response 200, 'steins_gate.xml'
		when "11770/12120/15336"
			xml_response 200, 'anime_batch.xml'
		when "11770/121200"
			xml_response 200, 'anime_batch_with_invalid.xml'
		else
			xml_response 200, 'no_result.xml'
		end
	end

	get '/encyclopedia/reports.xml' do
		xml_response 200, "list_report.xml"
	end

	private

		def xml_response(response_code, file_name)
			content_type :xml
			status response_code
			body File.open("#{File.dirname(__FILE__)}/fixtures/#{file_name}", 'rb').read
		end
end

