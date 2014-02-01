require 'sinatra/base'

class FakeANN < Sinatra::Base
	get '/encyclopedia/api.xml' do
		case params[:anime]
		when "11770"
			xml_response 200, 'steins_gate.xml'
		else
			xml_response 200, 'no_result.xml'
		end
	end

	private

		def xml_response(response_code, file_name)
			content_type :xml
			status response_code
			body File.open("#{File.dirname(__FILE__)}/fixtures/#{file_name}", 'rb').read
		end
end

