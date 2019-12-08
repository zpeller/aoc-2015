#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
	tokens = l.strip.scan(/^(.*) would (.*) (.*) happiness units by sitting next to (.*)\.$/)[0].freeze
	[tokens[0], tokens[3], tokens[1]=="gain" ? tokens[2].to_i : -(tokens[2].to_i)]
}.freeze

# print input,"\n"


def init_happiness_pairs(happiness_list)
	guests = []
	gained_happiness = Hash.new(0)
	happiness_list.each {|guest1, guest2, ghappiness|
		gained_happiness[[guest1, guest2].sort] += ghappiness
		guests = (guests + [guest1, guest2]).uniq
	}
	return guests, gained_happiness
end

guests, gained_happiness = init_happiness_pairs(input)

#print gained_happiness, "\n"
#print guests, "\n"
#puts

max_ghappiness_with_me = [0, []]	# open chain
max_ghappiness = [0, []]			# closed chain

guests.permutation.each { |guest_list|
	sum_ghappiness_with_me = guest_list.each_cons(2).to_a.inject(0) { |sum, guest_pair| 
		sum + gained_happiness[[guest_pair[0], guest_pair[1]].sort] 
	}
	sum_ghappiness = sum_ghappiness_with_me + gained_happiness[[guest_list[0], guest_list[-1]].sort]

	max_ghappiness_with_me = [max_ghappiness_with_me, [sum_ghappiness_with_me, guest_list]].max
	max_ghappiness = [max_ghappiness, [sum_ghappiness, guest_list]].max
}

print("Max happiness: #{max_ghappiness[0]} #{max_ghappiness[1]}\n")
print("Max happiness with me: #{max_ghappiness_with_me[0]} #{max_ghappiness_with_me[1]}\n")


__END__
Alice would gain 54 happiness units by sitting next to Bob.
Alice would lose 81 happiness units by sitting next to Carol.
Alice would lose 42 happiness units by sitting next to David.
Alice would gain 89 happiness units by sitting next to Eric.
Alice would lose 89 happiness units by sitting next to Frank.
Alice would gain 97 happiness units by sitting next to George.
Alice would lose 94 happiness units by sitting next to Mallory.
Bob would gain 3 happiness units by sitting next to Alice.
Bob would lose 70 happiness units by sitting next to Carol.
Bob would lose 31 happiness units by sitting next to David.
Bob would gain 72 happiness units by sitting next to Eric.
Bob would lose 25 happiness units by sitting next to Frank.
Bob would lose 95 happiness units by sitting next to George.
Bob would gain 11 happiness units by sitting next to Mallory.
Carol would lose 83 happiness units by sitting next to Alice.
Carol would gain 8 happiness units by sitting next to Bob.
Carol would gain 35 happiness units by sitting next to David.
Carol would gain 10 happiness units by sitting next to Eric.
Carol would gain 61 happiness units by sitting next to Frank.
Carol would gain 10 happiness units by sitting next to George.
Carol would gain 29 happiness units by sitting next to Mallory.
David would gain 67 happiness units by sitting next to Alice.
David would gain 25 happiness units by sitting next to Bob.
David would gain 48 happiness units by sitting next to Carol.
David would lose 65 happiness units by sitting next to Eric.
David would gain 8 happiness units by sitting next to Frank.
David would gain 84 happiness units by sitting next to George.
David would gain 9 happiness units by sitting next to Mallory.
Eric would lose 51 happiness units by sitting next to Alice.
Eric would lose 39 happiness units by sitting next to Bob.
Eric would gain 84 happiness units by sitting next to Carol.
Eric would lose 98 happiness units by sitting next to David.
Eric would lose 20 happiness units by sitting next to Frank.
Eric would lose 6 happiness units by sitting next to George.
Eric would gain 60 happiness units by sitting next to Mallory.
Frank would gain 51 happiness units by sitting next to Alice.
Frank would gain 79 happiness units by sitting next to Bob.
Frank would gain 88 happiness units by sitting next to Carol.
Frank would gain 33 happiness units by sitting next to David.
Frank would gain 43 happiness units by sitting next to Eric.
Frank would gain 77 happiness units by sitting next to George.
Frank would lose 3 happiness units by sitting next to Mallory.
George would lose 14 happiness units by sitting next to Alice.
George would lose 12 happiness units by sitting next to Bob.
George would lose 52 happiness units by sitting next to Carol.
George would gain 14 happiness units by sitting next to David.
George would lose 62 happiness units by sitting next to Eric.
George would lose 18 happiness units by sitting next to Frank.
George would lose 17 happiness units by sitting next to Mallory.
Mallory would lose 36 happiness units by sitting next to Alice.
Mallory would gain 76 happiness units by sitting next to Bob.
Mallory would lose 34 happiness units by sitting next to Carol.
Mallory would gain 37 happiness units by sitting next to David.
Mallory would gain 40 happiness units by sitting next to Eric.
Mallory would gain 18 happiness units by sitting next to Frank.
Mallory would gain 7 happiness units by sitting next to George.
