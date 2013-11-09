##################################################
# ANN_Wrapper
##################################################

require "net/http"
require "xml-object"
require File.join(File.expand_path(File.dirname(__FILE__)), './ANN_Objects')
require 'singleton'

# wrapper class for ANN API
class ANN_Wrapper
	include Singleton
	# ANN API anime url
	ANN_URL         = "http://cdn.animenewsnetwork.com/encyclopedia"
	ANN_API_URL     = "#{ANN_URL}/api.xml"
	ANN_REPORTS_URL = "#{ANN_URL}/reports.xml"

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
	def fetch_ann_anime(id)
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

	# fetch list of titles via reports
	def fetch_titles(type="anime", nskip=0, nlist=50, name="")
		url = "#{ANN_REPORTS_URL}?id=155&type=#{type}&nskip=#{nskip}&nlist=#{nlist}"
		data = _fetch_data(url)

		return ANN_Error.new("No response") if data.nil?

		begin
			report = XMLObject.new(data)
		rescue
			return ANN_Error.new("xml format error, API likely unavailable")
		end

		report.items.map do |item|
			ANN_Report.new(item)
		end
	end
end
