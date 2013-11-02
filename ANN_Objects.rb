##################################################
# ANN_Objects
##################################################

ANN_Error   = Struct.new(:message)
ANN_Staff   = Struct.new(:id, :task, :name)
ANN_Episode = Struct.new(:number, :title, :lang)

class ANN_Anime
	# ann_anime XMLObject
	attr_writer :ann_anime

	# initialize with XMLObject 
	def initialize(ann_anime)
		@ann_anime = ann_anime

		@info = Hash.new
		@info[:synopsis]      = "Plot Summary"
		@info[:num_episodes]  = "Number of episodes"
		@info[:genres]        = "Genres"
		@info[:themes]        = "Themes"
		@info[:title]         = "Main title"
		@info[:vintage]       = "Vintage"
		@info[:op_theme]      = "Opening Theme"
		@info[:ed_theme]      = "Ending Theme"

		@info.each do |name, key|
			create_method(name) { find_info(key) }
		end
	end

	# return all info with provided key
	def find_info(key)
		@ann_anime.info.find_all {|info| info.type.eql?(key)}
	end

	# return all episodes
	def episodes
		@episodes ||= @ann_anime.episodes.map do |e|
			ANN_Episode.new(e.num, e.title, e.title.lang)
		end
	end

	# return all staff
	def staff
		@staff ||= @ann_anime.staff.map do |s|
			ANN_Staff.new(s.person.id, s.task, s.person)
		end
	end

private
		def create_method(name, &block)
			self.class.send(:define_method, name, &block)
		end

	private :create_method
end

