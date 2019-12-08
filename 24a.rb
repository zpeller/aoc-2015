#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map(&:to_i).freeze

print(input, "\n")

#input.each {|l|
#	print(l, "\n")
#}

def groups_dividable(group, weight)
	(1..group.length-1).each { |group1_pkgs_cnt|
		if group.combination(group1_pkgs_cnt).select { |group1| group1.inject(:+) == weight }.length > 0
			return true
		end
	}
	return false
end

def find_smallest_group(input)
	group_weight = input.inject(:+)/3
	smallest_qe = [1000000000000, []]
	min_group_length = -1
	num_first_group_packages = 1
	(1..input.length-2).each { |group1_pkgs_cnt|
		input.combination(group1_pkgs_cnt).select { |group1| group1.inject(:+) == group_weight }.each { |group1|
			group23 = input - group1
			print("#{group1} #{group23}\n")
			if groups_dividable(group23, group_weight)
				min_group_length = group1_pkgs_cnt
				qe = group1.inject(:*)
				smallest_qe = [smallest_qe, [qe, group1]].min
			end
		}
		if min_group_length>0
			break
		end
	}
	return smallest_qe
end

print("Problem 1 smallest quantum entanglement: #{find_smallest_group(input)}\n")


__END__
1
3
5
11
13
17
19
23
29
31
41
43
47
53
59
61
67
71
73
79
83
89
97
101
103
107
109
113
