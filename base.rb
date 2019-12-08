#!/usr/bin/ruby

require 'pp'

input = (ARGV.empty? ? DATA : ARGF).each_line.map(&:to_i).freeze
input = (ARGV.empty? ? DATA : ARGF).each_line.map(&:strip).freeze
input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
	tokens = l.strip.scan(/^(.*) to (.*) = (.*)$/)[0].freeze
	nums = l.scan(/-?\d+/).map(&:to_i)
	l.scan(/([LR])(\d+)/).freeze
	[tokens[0], tokens[1]]
}.freeze

pp input

input.each {|l|
	print(l, "\n")
}

__END__
