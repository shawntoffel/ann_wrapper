##################################################
# ANN_Wrapper
##################################################

require "net/http"
require "nokogiri"
require 'ann_wrapper/ann_objects'

# wrapper class for ANN API
module ANN_Wrapper
extend ANN_Wrapper

	# ANN API anime url
	ANN_URL         = "http://cdn.animenewsnetwork.com/encyclopedia"
	ANN_API_URL     = "#{ANN_URL}/api.xml"
	ANN_REPORTS_URL = "#{ANN_URL}/reports.xml"

	# fetch up to 50 anime in one request
	def batch_anime(ids, api_url=ANN_API_URL)
		# append id to API url and send request
		url = "#{api_url}?title=#{ids.first.to_s}"
		ids[1..-1].each do |id|
			url << "/#{id.to_s}"
		end

		ann = fetch(url)

		return [ann] if ann.is_a?(ANN_Error)

		all_anime = ann.xpath('//ann/anime')
		warnings = ann.xpath('//ann/warning')

		return [ANN_Error.new(get_xml_error(ann))] if all_anime.nil?

		#all_anime.map { |anime| anime.nil? ? ANN_Error(get_xml_error(anime)) : ANN_Anime.new(anime) }
		all_anime.map { |anime| ANN_Anime.new(anime) } + warnings.map { |warning| ANN_Error.new(get_xml_error(warning)) }
	end

	# fetch anime and convert to ANN_Anime
	def fetch_anime(id, api_url=ANN_API_URL)
		batch_anime([id], api_url).first
	end

	# fetch list of titles via reports
	def fetch_titles(type="anime", nskip=0, nlist=50, name="", api_url=ANN_REPORTS_URL)
		url = "#{api_url}?id=155&type=#{type}&nskip=#{nskip}&nlist=#{nlist}"
		report = fetch(url)

		return report if report.is_a?(ANN_Error)

		reports = report.xpath('//report/item')

		return ANN_Error.new(get_xml_error(report)) if reports.nil?

		reports.map { |item| ANN_Report.new(item) }
	end

	private
		# fetch data from ANN API via http GET request
		# returns Nokogiri or ANN_Error
		def fetch(url)
			begin
				# send http GET request with uri parsed from url
				resp = Net::HTTP.get_response(URI.parse(url))

				# get the response body and try converting to Nokogiri object
				Nokogiri.XML(resp.body)
			rescue
				ANN_Error.new("Could not reach valid URL")
			end
		end	

		# attempt to grab error message from XMLObject
		def get_xml_error(xobj)
			begin
				xobj.at_xpath('//ann/warning').content
			rescue NoMethodError
				"unrecognized response body"
			end
		end
	end
