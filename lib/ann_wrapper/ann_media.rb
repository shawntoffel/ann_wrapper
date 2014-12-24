require_relative 'ann'

class ANN_Media < ANN

	# @return [Nokogiri::XML::NodeSet] return all info with provided key
	def find_info(obj, key)
		obj.search("info[@type=\"#{key}\"]")
	end

	# create methods inside calling object
	def create_methods(obj, dictionary)
		dictionary.each do |name, key|
			create_method(name) do
				# find_info in calling object
				info = find_info(key)
				return nil if info.nil?
				info.map do |i|
					i.content
				end
			end
		end
	end

	# @return [[String]] returns title(s)
	def title; end
	# @return [[String]] returns synopsis
	def synopsis; end
	# @return [[String]] returns array of genres
	def genres; end
	# @return [[String]] returns array of themes
	def themes; end
	# @return [[String]] returns array of vintage(s)
	def vintage; end

	# @return [[ANN_Image]] returns array of ANN_Image
	def images
		@images ||= find_info("Picture").xpath("./img").map do |i|
			ANN_Image.new(i['src'], i['width'], i['height'])
		end
	end

	# @return [[ANN_Staff]] returns array of ANN_Staff
	def staff(obj)
		@staff ||= obj.xpath("./staff").map do |s|
			task = s.at_xpath("task")
			person = s.at_xpath("person")
			ANN_Staff.new(person['id'], task.content, person.content)
		end
	end

	# @return [Hash] returns hash of titles grouped by language abbreviation
	def alt_titles
		titles = find_info("Alternative title").group_by {|title| title['lang']}
		titles.each do |key, value|
			value.map! do |title|
				title.content
			end
		end
	end

	# @return [[ANN_Rating]] returns array of ANN_Episode
	def ratings(obj)
		@ratings ||= obj.xpath("./ratings").map do |r|
			ANN_Rating.new(r['nb_votes'], r['weighted_score'], r['bayesian_score'])
		end
	end
end
