##################################################
# ANN_Wrapper
##################################################

require "net/http"
require "nokogiri"
require 'ann_wrapper/ann_anime'
require 'ann_wrapper/ann_manga'
require 'ann_wrapper/ann_report'

# wrapper class for ANN API
module ANN_Wrapper
extend ANN_Wrapper

	@@type = "anime"

	# ANN API anime url
	ANN_URL         = "http://cdn.animenewsnetwork.com/encyclopedia"
	ANN_API_URL     = "#{ANN_URL}/api.xml"
	ANN_REPORTS_URL = "#{ANN_URL}/reports.xml"

	# fetch up to 50 items(Animes or Mangas) in one request
	def batch_items(ids, api_url=ANN_API_URL)
		# append id to API url and send request
		url = "#{api_url}?title=#{ids.first.to_s}"
		ids[1..-1].each do |id|
			url << "/#{id.to_s}"
		end

		ann = fetch(url)

		return [ann] if ann.is_a?(ANN_Error)

		all_items = ann.xpath("//ann/#{@@type}")
		warnings = ann.xpath('//ann/warning')

		return [ANN_Error.new(get_xml_error(ann))] if all_items.empty? and warnings.empty?

		all_items = all_items.map { |item| Object.const_get("ANN_#{@@type.capitalize}").new(item) }
		warnings = warnings.map { |warning| ANN_Error.new(get_xml_error(warning)) }

		all_items.push(*warnings)
	end

	# fetch anime and convert to ANN_Anime
	def fetch_item(id, api_url=ANN_API_URL)
		batch_items([id], api_url).first
	end

	# fetch list of titles via reports
	def fetch_titles(options = {})
		options[:type]    ||= "anime"
		options[:nskip]   ||= 0
		options[:nlist]   ||= 50
		options[:name]    ||= ""
		options[:api_url] ||= ANN_REPORTS_URL

		url = "#{options[:api_url]}?id=155&type=#{options[:type]}&name=#{options[:name]}&nskip=#{options[:nskip]}&nlist=#{options[:nlist]}"

		report = fetch(url)

		return report if report.is_a?(ANN_Error)

		reports = report.xpath('//report/item')

		return ANN_Error.new(get_xml_error(report)) if reports.nil?

		reports.map { |item| ANN_Report.new(item) }
	end

  def method_missing(meth, *args, &block)
    if meth.to_s =~ /^(fetch|batch)_(anime|manga)$/
      @@type = $2
      $1 == 'fetch' ? fetch_item(*args) : batch_items(*args)
    else
      super
    end
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
