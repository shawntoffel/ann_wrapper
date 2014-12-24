# parent with helper methods
class ANN
	private
		##
		# define method with supplied name and block
		def create_method(name, &block)
			self.class.send(:define_method, name, &block)
		end


		# return hash of methods and returns excluding those in excludes
		def to_hash(excludes)
			# get list of methods excluding above
			methods = self.class.instance_methods(false).reject {|m| excludes.include? m}

			# map methods and results to hash
			data = methods.map do |method |
				result = self.send(method)

				# convert Structs to hash
				if (result.is_a? Array)
					result.map! do |item|
						item.is_a?(Struct) ? item.hash : item
					end
				else
					result.hash! if result.is_a?(Struct)
				end

				# make hash with method name and result of call
				[method.to_sym, result]
			end

			# return hash
			Hash[data]
		end
	end

# various ANN struct types
ANN_Error   = Struct.new(:message)
ANN_Staff   = Struct.new(:id, :task, :name)
ANN_Cast    = Struct.new(:id, :role, :name, :lang)
ANN_Episode = Struct.new(:number, :title, :lang)
ANN_Image   = Struct.new(:src, :width, :height)
ANN_Rating	= Struct.new(:votes, :weighted, :bayesian_score)
