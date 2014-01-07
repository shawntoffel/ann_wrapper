##################################################
# ANN_Objects
##################################################

# parent with helper methods
class ANN
private
		# define method with supplied name and block
		def create_method(name, &block)
			self.class.send(:define_method, name, &block)
		end
end

# various ANN struct types
ANN_Error   = Struct.new(:message)
ANN_Staff   = Struct.new(:id, :task, :name)
ANN_Cast    = Struct.new(:id, :role, :name, :lang)
ANN_Episode = Struct.new(:number, :title, :lang)
ANN_Image   = Struct.new(:src, :width, :height)

class ANN_Anime < ANN
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
		@info.each do |name, key|
			create_method(name) do 
				info = find_info(key)
				return nil if info.nil?
				info.map do |i|
					i.content
				end
			end
		end

	end

	# return all info with provided key
	def find_info(key)
		begin
			@ann_anime.search("info[@type=\"#{key}\"]")
		rescue 
			nil
		end
	end

	# returns array of titles grouped by language abbreviation
	def alt_titles
		begin
			titles = find_info("Alternative title").group_by {|title| title['lang']}

			titles.each do |key, value|
				value.map! do |title|
					title.content
				end
			end
		rescue NameError
			nil
		end
	end

	def type
		@type ||= @ann_anime['type']
	end
		
	# returns array of ANN_Image
	def images
		begin
			@images ||= find_info("Picture").map do |i|
				ANN_Image.new(i['src'], i['width'], i['height'])
			end
		rescue NameError
			nil
		end
	end

	# returns array of ANN_Episode
	def episodes
		begin
			@episodes ||= @ann_anime.xpath("//episode").map do |e|
				title = e.at_xpath("title")
				ANN_Episode.new(e['num'], title.content, title['lang'])
			end
		rescue NameError
			nil
		end
	end

	# returns array of ANN_Staff
	def staff
		begin
			@staff ||= @ann_anime.xpath("//staff").map do |s|
				task = s.at_xpath("task")
				person = s.at_xpath("person")
				ANN_Staff.new(person['id'], task.content, person.content)
			end
		rescue NameError
			nil
		end
	end

	# returns array of ANN_Cast
	def cast
		begin
			@cast ||= @ann_anime.xpath("//cast").map do |s|
				role = s.at_xpath("role")
				person = s.at_xpath("person")
				ANN_Cast.new(person['id'], role.content, person.content, s['lang'])
			end
		rescue NameError
			nil
		end
	end
end

class ANN_Report < ANN
	# initialize and build access methods
	def initialize(ann_report)
		@id, @type, @name, @precision, @vintage = ""

		self.instance_variables.each do |iv|
			var_name = iv.to_s.partition("@").last
			create_method(var_name) { get_info_on(ann_report, var_name) }
		end
	end

	# get info from xml
	def get_info_on(ann_report, var_name)
		begin 
			ann_report.at_xpath(var_name).content
		rescue NameError
			nil
		end
	end
end
