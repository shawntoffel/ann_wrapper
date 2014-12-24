require_relative 'ann'

class ANN_Report < ANN
	# initialize and build access methods
	def initialize(ann_report)
		@id, @type, @name, @precision, @vintage = ""
		@ann_report = ann_report

		self.instance_variables.each do |iv|
			var_name = iv[1..-1]
			create_method(var_name) { get_info_on(var_name) }
		end
	end

	# get info from xml
	def get_info_on(var_name)
		body = @ann_report.at_xpath(var_name)
		body.content unless body.nil?
	end

	# @return [Hash] hash of self
	def to_h
		# create hash excluding some methods
		to_hash([:to_h, :ann_report, :get_info_on])
	end
end
