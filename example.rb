#!/usr/bin/ruby

##########################################
#
# Example usage of ANN wrapper and methods
#
##########################################

require './ANN_Wrapper'

begin
	# create new ANN API Wrapper
	ann_wrapper = ANN__Wrapper.new

	# fetch ANN_Anime by id
	steins_gate = ann_wrapper.fetch_ann_anime(11770)

	if steins_gate.is_a?(ANN_Error)
		puts steins_gate.message
		exit(1)
	end

	puts steins_gate.synopsis
	puts steins_gate.num_episodes
	puts steins_gate.genres
	puts steins_gate.themes
	puts steins_gate.op_theme
	puts steins_gate.ed_theme
	puts steins_gate.episodes
	puts steins_gate.staff

	puts steins_gate.respond_to?('synopsis')

rescue
	puts "oops"

	# print last exception and backtrace
	puts $!.inspect, $@
end
