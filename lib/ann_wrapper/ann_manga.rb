require_relative 'ann_media'

class	ANN_Manga < ANN_Media
	# ann_anime Nokogiri object
	attr_writer :ann_manga

	def initialize(ann_manga)
		@ann_manga = ann_manga

		# information available from detail
		@info = Hash.new
		@info[:title]         			= "Main title"
		@info[:synopsis]      			= "Plot Summary"
		@info[:genres]        			= "Genres"
		@info[:vintage]       			= "Vintage"
		@info[:themes]        			= "Themes"
		@info[:num_tankoubon] = "Number of tankoubon"
		@info[:num_pages]						= "Number of pages"

		# create methods
		create_methods(@ann_manga, @info)
	end

	# @return [Nokogiri::XML::NodeSet] return all info with provided key
	def find_info(key)
		super(@ann_manga, key)
	end

	# @return [String] returns manga id
	def id
		@id ||= @ann_manga['id']
	end

	# @return [String] returns manga type
	def type
		@type ||= @ann_manga['type']
	end

	# @return [[ANN_Staff]] returns array of ANN_Staff
	def staff
		super @ann_manga
	end

	# @return [[ANN_Rating]] returns array of ANN_Episode
	def ratings
		super @ann_manga
	end

	# @return [Hash] hash of self
	def to_h
		# create hash excluding some methods
		to_hash([:to_h, :ann_manga=, :find_info])
	end

	##
	# These methods are created via create_method in the constructor

	# @return [[String]] returns the number of tankoubon
	def num_tankoubon; end

	# @return [[String]] returns the number of tankoubon
	def num_pages; end
end
