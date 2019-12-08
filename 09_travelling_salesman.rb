#!/usr/bin/ruby

# input = (ARGV.empty? ? DATA : ARGF).each_line.map(&:to_i).freeze
input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
	tokens = l.strip.scan(/^(.*) to (.*) = (.*)$/)[0].freeze
	[tokens[0], tokens[1], tokens[2].to_i]
}.freeze

print input,"\n"

distances = {}
cities = []
input.each {|from, to, dst|
	distances[[from,to].sort] = dst
	cities = (cities + [from, to]).uniq
}

# print distances, "\n"
# print cities, "\n"

min_dst = 1000000000
max_dst = 0
min_city_list = []
max_city_list = []
cities.permutation.each { |city_list|
	sum_dst = 0
	prev_city = ''

	city_list.each { |city|
		if prev_city != ''
			sum_dst += distances[[prev_city, city].sort]
		end
		prev_city = city
	}

	if min_dst>sum_dst
		min_city_list = city_list
		min_dst = sum_dst
	end
	if max_dst<sum_dst
		max_city_list = city_list
		max_dst = sum_dst
	end
}

print("Min cities: #{min_city_list} dst: #{min_dst}\n")
print("Max cities: #{max_city_list} dst: #{max_dst}\n")


__END__
AlphaCentauri to Snowdin = 66
AlphaCentauri to Tambi = 28
AlphaCentauri to Faerun = 60
AlphaCentauri to Norrath = 34
AlphaCentauri to Straylight = 34
AlphaCentauri to Tristram = 3
AlphaCentauri to Arbre = 108
Snowdin to Tambi = 22
Snowdin to Faerun = 12
Snowdin to Norrath = 91
Snowdin to Straylight = 121
Snowdin to Tristram = 111
Snowdin to Arbre = 71
Tambi to Faerun = 39
Tambi to Norrath = 113
Tambi to Straylight = 130
Tambi to Tristram = 35
Tambi to Arbre = 40
Faerun to Norrath = 63
Faerun to Straylight = 21
Faerun to Tristram = 57
Faerun to Arbre = 83
Norrath to Straylight = 9
Norrath to Tristram = 50
Norrath to Arbre = 60
Straylight to Tristram = 27
Straylight to Arbre = 81
Tristram to Arbre = 90
