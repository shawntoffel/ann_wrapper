##################################################
# ANN_Wrapper
##################################################

require "net/http"
require "xml-object"
require './ANN_Objects'

# wrapper class for ANN API
class ANN__Wrapper
	# ANN API anime url
	ANN_URL = "http://cdn.animenewsnetwork.com/encyclopedia/api.xml"

	# fetch data from ANN API via http GET request
	def _fetch_data(url)
		begin
			# send http GET request with uri parsed from url
			resp = Net::HTTP.get_response(URI.parse(url))

			# get the response body
			resp.body
		rescue
			nil
		end
	end	

	# fetch xml and deserialize to object
	def fetch_ann_anime(*args)
		args.map do |id|
			# append id to API url and send request
			data = _fetch_data("#{ANN_URL}?anime=#{id.to_s}")

			return ANN_Error.new("No response") if data.nil?

			# 'deserialize' returned xml to ann object
			ann = XMLObject.new(data)

			# initialize new ann_anime or error with ann object
			begin
				ANN_Anime.new(ann.anime)
			rescue NameError => e
				# ANN always provides an error warning
				ANN_Error.new(ann.warning)
			end
		end
	end
end


