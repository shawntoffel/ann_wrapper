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
	# returns XMLObject or ANN_Error
	def fetch(url)
		begin
			# send http GET request with uri parsed from url
			resp = Net::HTTP.get_response(URI.parse(url))

			# get the response body and try converting to object
			XMLObject.new(resp.body)
		rescue
			ANN_Error.new("xml format error, API likely unavailable")
		end
	end	

	# attempt to grab error message from XMLObject
	def get_xml_error(xobj)
		begin
			xobj.warning
		rescue NameError
			"bad response"
		end
	end

	# fetch anime and convert to ANN_Anime
	def fetch_ann_anime(id)
		# append id to API url and send request
		url = "#{ANN_API_URL}?anime=#{id.to_s}"

		ann = fetch(url)

		return ann if ann.is_a?(ANN_Error)

		# initialize new ann_anime or error with ann object
		begin
			ANN_Anime.new(ann.anime)
		rescue NameError
			ANN_Error.new(get_xml_error(ann))
		end
	end

	# fetch list of titles via reports
	def fetch_titles(type="anime", nskip=0, nlist=50, name="")
		url = "#{ANN_REPORTS_URL}?id=155&type=#{type}&nskip=#{nskip}&nlist=#{nlist}"
		report  = fetch(url)

		return report if report.is_a?(ANN_Error)

		begin
			report.items.map do |item|
				ANN_Report.new(item)
			end
		rescue NameError
			return ANN_Error.new(get_xml_error(report))
		end

		report.item

	end
end
