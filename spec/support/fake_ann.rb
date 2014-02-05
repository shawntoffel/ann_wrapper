require 'sinatra/base'

class FakeANN < Sinatra::Base
	get '/encyclopedia/api.xml' do
		case params[:anime]
		when "11770"
			xml_response 200, 'steins_gate.xml'
		when "46580"
			xml_response 200, 'invalid_warning.xml'
		else
			xml_response 200, 'no_result.xml'
		end
	end

	get '/encyclopedia/reports.xml' do
		xml_response 200, "list_report.xml"
	end

	get '/invalid_url' do
		status 404
	end

	private

		def xml_response(response_code, file_name)
			content_type :xml
			status response_code
			body File.open("#{File.dirname(__FILE__)}/fixtures/#{file_name}", 'rb').read
		end
end

