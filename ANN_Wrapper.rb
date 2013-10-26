require "net/http"
require "xml-object"

# wrapper class for ANN API
class ANN__Wrapper
	# ANN API anime url
	ANN_ANIME_URL = "http://cdn.animenewsnetwork.com/encyclopedia/api.xml?anime="

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
		data = _fetch_data(ANN_ANIME_URL << id.to_s)

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

class ANN_Anime
	# ann_anime XMLObject
	attr_accessor :ann_anime

	# initialize with XMLObject 
	def initialize(ann_anime)
		@ann_anime = ann_anime

		@info = Hash.new
		@info[:synopsis]     = "Plot Summary"
		@info[:num_episodes] = "Number of episodes"
		@info[:genres]       = "Genres"
		@info[:title]        = "Main title"
		@info[:vintage]      = "Vintage"
	end

	# return all info with provided key
	def find_info(key)
		@ann_anime.info.find_all {|info| info.type.eql?(key)}
	end

	# call methods from hash
	def method_missing(name, *args, &block)
		if (args.empty? && block.nil? && @info.has_key?(name))
			find_info(@info[name])
		else
			super
		end
	end

	# add hash methods to respond_to and #method
	def respond_to_missing?(name, include_private = false)
		@info.has_key?(name) || super
	end
end

class ANN_Error
	attr_accessor :message
	
	def initialize(message)
		@message = message
	end
end
