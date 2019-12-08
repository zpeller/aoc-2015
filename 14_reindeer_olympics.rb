#!/usr/bin/ruby

RACE_TIME = 2503
#RACE_TIME = 1000

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
	tokens = l.scan(/^(.*) can fly (.*) km.s for (.*) seconds.*for (.*) seconds.$/)[0].freeze
	[tokens[0], tokens[1].to_i, tokens[2].to_i, tokens[3].to_i]
}.freeze

# print(input, "\n")

def distance_travelled(time_spent, speed, fly_time, rest_time)
	time_period = fly_time+rest_time

	full_cycles = time_spent/time_period
	travelled_distance = full_cycles*fly_time*speed

	split_time = time_spent % time_period
	if split_time > fly_time
		travelled_distance += fly_time * speed
	else
		travelled_distance += split_time * speed
	end
	return travelled_distance
end

def max_distance_reindeer(reindeers, travel_time)
	max_reindeer = [0, ['']]
	reindeers.each {|name, speed, fly_time, rest_time|
		td = distance_travelled(travel_time, speed, fly_time, rest_time)
		if max_reindeer[0] == td
			max_reindeer[1] += [name]
#			print("Reindeers in the leed: #{max_reindeer}\n")
		else
			max_reindeer = [max_reindeer, [td, [name]]].max
		end
#		print("Reindeer #{name} dist: #{td}\n")
	}
	return max_reindeer
end

max_rd = max_distance_reindeer(input, RACE_TIME)
print("Max distance: #{max_rd[0]} by #{max_rd[1]}\n")

scores = Hash.new(0)
(1..RACE_TIME).each { |travel_time|
	leaders = max_distance_reindeer(input, travel_time)[1]
	leaders.each { |name|
		scores[name] += 1
	}
}
print("Final scores: #{scores}\n")


__END__
Dancer can fly 27 km/s for 5 seconds, but then must rest for 132 seconds.
Cupid can fly 22 km/s for 2 seconds, but then must rest for 41 seconds.
Rudolph can fly 11 km/s for 5 seconds, but then must rest for 48 seconds.
Donner can fly 28 km/s for 5 seconds, but then must rest for 134 seconds.
Dasher can fly 4 km/s for 16 seconds, but then must rest for 55 seconds.
Blitzen can fly 14 km/s for 3 seconds, but then must rest for 38 seconds.
Prancer can fly 3 km/s for 21 seconds, but then must rest for 40 seconds.
Comet can fly 18 km/s for 6 seconds, but then must rest for 103 seconds.
Vixen can fly 18 km/s for 5 seconds, but then must rest for 84 seconds.
