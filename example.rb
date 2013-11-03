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

	steins_gate = ann_wrapper.fetch_ann_anime(11770)

	if steins_gate.is_a?(ANN_Error)
		puts steins_gate.message
		exit(1)
	end

	puts steins_gate.title
	puts steins_gate.lang_titles
	puts steins_gate.synopsis
	puts steins_gate.num_episodes
	puts steins_gate.genres
	puts steins_gate.themes
	puts steins_gate.op_theme
	puts steins_gate.ed_theme
	puts steins_gate.episodes
	puts steins_gate.staff
	puts steins_gate.cast
	puts steins_gate.images

rescue
	puts "oops"

	# print last exception and backtrace
	puts $!.inspect, $@
end
