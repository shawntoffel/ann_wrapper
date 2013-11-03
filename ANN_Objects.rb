##################################################
# ANN_Objects
##################################################

ANN_Error   = Struct.new(:message)
ANN_Staff   = Struct.new(:id, :task, :name)
ANN_Cast    = Struct.new(:id, :role, :name)
ANN_Episode = Struct.new(:number, :title, :lang)
ANN_Image   = Struct.new(:src, :width, :height)

class ANN_Anime
	# ann_anime XMLObject
	attr_writer :ann_anime

	# initialize with XMLObject 
	def initialize(ann_anime)
		@ann_anime = ann_anime

		# information available from detail
		@info = Hash.new
		@info[:title]         = "Main title"
		@info[:alt_titles]    = "Alternative title"
		@info[:synopsis]      = "Plot Summary"
		@info[:num_episodes]  = "Number of episodes"
		@info[:genres]        = "Genres"
		@info[:themes]        = "Themes"
		@info[:title]         = "Main title"
		@info[:vintage]       = "Vintage"
		@info[:op_theme]      = "Opening Theme"
		@info[:ed_theme]      = "Ending Theme"

		# create methods
		@info.each do |name, key|
			create_method(name) { find_info(key) }
		end
	end

	# return all info with provided key
	def find_info(key)
		@ann_anime.info.find_all {|info| info.type.eql?(key)}
	end

	# returns array of titles grouped by language abbreviation
	def lang_titles
		@lang_titles ||= alt_titles.group_by {|title| title.lang}
	end
		
	# returns array of ANN_Image
	def images
		@images ||= find_info("Picture").map do |i|
			ANN_Image.new(i.src, i.width, i.height)
		end
	end

	# returns array of ANN_Episode
	def episodes
		@episodes ||= @ann_anime.episodes.map do |e|
			ANN_Episode.new(e.num, e.title, e.title.lang)
		end
	end

	# returns array of ANN_Staff
	def staff
		@staff ||= @ann_anime.staff.map do |s|
			ANN_Staff.new(s.person.id, s.task, s.person)
		end
	end

	# returns array of ANN_Cast
	def cast
		@cast ||= @ann_anime.cast.map do |s|
			ANN_Cast.new(s.person.id, s.role, s.person)
		end
	end

private
		# define method with supplied name and block
		def create_method(name, &block)
			self.class.send(:define_method, name, &block)
		end
end
