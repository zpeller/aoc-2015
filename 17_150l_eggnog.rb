#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map(&:to_i).freeze

print(input, "\n")

TOTAL_EGGNOG = 150

no_of_combs = 0
found = false
(1..(input.count-1)).each { |number_of_containers|
	input.combination(number_of_containers).each { |comb|
		no_of_combs += 1 if comb.inject(:+) == TOTAL_EGGNOG
	}
	if not found and no_of_combs > 0
		print("Minimum no of containers: #{number_of_containers}, combinations: #{no_of_combs}\n")
		found = true
	end
}

print("No of combinations: #{no_of_combs}\n")


__END__
50
44
11
49
42
46
18
32
26
40
21
7
18
43
10
47
36
24
22
40
