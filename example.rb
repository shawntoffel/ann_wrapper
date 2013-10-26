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

	puts steins_gate.synopsis
	puts steins_gate.episodes
	puts steins_gate.genres

	puts steins_gate.respond_to?('genres')

	# print all info by type
	#steins_gate.print_all_info

	# print all episodes by number and title
#	steins_gate.print_all_episodes

	# print all staff by task and name
	#steins_gate.print_all_staff

rescue
	puts "oops"

	# print last exception and backtrace
	puts $!, $@
end
