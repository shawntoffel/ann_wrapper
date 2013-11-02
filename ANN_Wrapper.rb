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

Rule = Struct.new(:key, :method)
ANN_Error = Struct.new(:message)
ANN_Episode = Struct.new(:number, :title, :lang)
ANN_Staff = Struct.new(:id, :task, :name)

class ANN_Anime
	# ann_anime XMLObject
	attr_accessor :ann_anime

	# initialize with XMLObject 
	def initialize(ann_anime)
		@ann_anime = ann_anime


		@info = Hash.new

		@info[:synopsis]      = Rule.new("Plot Summary", :find_info)
		@info[:num_episodes]  = Rule.new("Number of episodes", :find_info)
		@info[:genres]        = Rule.new("Genres", :find_info)
		@info[:themes]        = Rule.new("Themes" , :find_info)
		@info[:title]         = Rule.new("Main title", :find_info)
		@info[:vintage]       = Rule.new("Vintage" , :find_info)
		@info[:op_theme]      = Rule.new("Opening Theme", :find_info)
		@info[:ed_theme]      = Rule.new("Ending Theme", :find_info)
		@info[:episodes]      = Rule.new("", :find_episodes)
		@info[:staff]         = Rule.new("", :find_staff)

	end

	# return all info with provided key
	def find_info(key)
		@ann_anime.info.find_all {|info| info.type.eql?(key)}
	end

	# return all episodes with provided key
	def find_episodes(key)
		episodes = Array.new
		@ann_anime.episode.each do |episode|
			episodes.push(ANN_Episode.new(episode.num, episode.title, episode.title.lang))
		end
		episodes
	end

	def find_staff(key)
		staff_members = Array.new
		@ann_anime.staff.each do |staff|
			staff_members.push(ANN_Staff.new(staff.person.id, staff.task, staff.person))
		end
		staff_members
	end

	# call methods from hash
	def method_missing(name, *args, &block)
		if (args.empty? && block.nil? && @info.has_key?(name))
				self.send(@info[name].method, @info[name].key)
		else
			super
		end
	end

	# add hash methods to respond_to and #method
	def respond_to_missing?(name, include_private = false)
		@info.has_key?(name) || super
	end
end

