require_relative 'ann_media'

class ANN_Anime < ANN_Media
	# ann_anime Nokogiri object
	attr_writer :ann_anime


	# initialize and create info methods
	def initialize(ann_anime)
		@ann_anime = ann_anime

		# information available from detail
		@info = Hash.new
		@info[:title]         = "Main title"
		@info[:synopsis]      = "Plot Summary"
		@info[:num_episodes]  = "Number of episodes"
		@info[:genres]        = "Genres"
		@info[:themes]        = "Themes"
		@info[:vintage]       = "Vintage"
		@info[:op_theme]      = "Opening Theme"
		@info[:ed_theme]      = "Ending Theme"

		# create methods
		create_methods(@ann_anime, @info)

	end

	# @return [Nokogiri::XML::NodeSet] return all info with provided key
	def find_info(key)
		super(@ann_anime, key)
	end

	# @return [String] returns anime id
	def id
		@id ||= @ann_anime['id']
	end

	# @return [String] returns anime type
	def type
		@type ||= @ann_anime['type']
	end

	# @return [[ANN_Episode]] returns array of ANN_Episode
	def episodes
		@episodes ||= @ann_anime.xpath("./episode").map do |e|
			title = e.at_xpath("title")
			ANN_Episode.new(e['num'], title.content, title['lang'])
		end
	end

	# @return [[ANN_Cast]] returns array of ANN_Cast
	def cast
		@cast ||= @ann_anime.xpath("./cast").map do |s|
			role = s.at_xpath("role")
			person = s.at_xpath("person")
			ANN_Cast.new(person['id'], role.content, person.content, s['lang'])
		end
	end

	# @return [[ANN_Staff]] returns array of ANN_Staff
	def staff
		super @ann_anime
	end

	# @return [Hash] hash of self
	def to_h
		# create hash excluding some methods
		to_hash([:to_h, :ann_anime=, :find_info])
	end

	##
	# These methods are created via create_method in the constructor

	# @return [[String]] returns number of episodes
	def num_episodes; end
	# @return [[String]] returns op theme(s)
	def op_theme; end
	# @return [[String]] returns ed theme(s)
	def ed_theme; end
end
