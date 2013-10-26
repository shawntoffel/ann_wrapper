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
			data = resp.body
		rescue
			return nil
		end
	end	

	# fetch xml and deserialize to object
	def fetch_ann_anime(id)
		# append id to API url and send request
		data = _fetch_data(ANN_ANIME_URL << id.to_s)

		# 'deserialize' returned xml to ann object
		ann = XMLObject.new(data)

		# initialize new ann_anime with anime in ann object
		ann_anime = ANN_Anime.new(ann.anime)
	end
end

class ANN_Anime
	# ann_anime XMLObject
	attr_accessor :ann_anime

	# initialize with XMLObject 
	def initialize(ann_anime)
		@ann_anime = ann_anime

		@info["synopsis"] = "Plot Summary"
	end

	def find_info(key)
		@ann_anime.info.find_all {|info| info.type.eql?(key)}
	end

	def synopsis
		find_info("Plot Summary")
	end

	def episodes
		find_info("Number of episodes")
	end

	def genres
		find_info("Genres")
	end

	def title
		find_info("Main title")
	end

	def image
		find_info("Picture")
	end

	def vintage
		find_info("Vintage")
	end

	def method_missing(name, *args, &blk)
		if (args.empty? && blk.nil? && @info.has_key(name)
			find_info(@info[name])
		else
			super
		end
	end


	# helper to print a dash between two objects
	def formatted_print(first, second)
			puts "#{first} - #{second}"
	end

	# print all the anime's info with type and value
	def print_all_info
		@ann_anime.info.each do |info|
			formatted_print(info.type, info)
		end
	end

	# print all the anime's episodes with number and title
	def print_all_episodes
		@ann_anime.episodes.each do |episode|
			formatted_print(episode.num, episode.title)
		end
	end

	# print all the anime's staff with task and name
	def print_all_staff
		@ann_anime.staff.each do |staff|
			formatted_print(staff.task, staff.person)
		end
	end
end
