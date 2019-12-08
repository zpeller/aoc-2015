#!/usr/bin/ruby

require 'prime'

input = 34000000

input1 = input/10.0
input2 = input/11.0

def factors_of(number)
  primes, powers = number.prime_division.transpose
  exponents = powers.map{|i| (0..i).to_a}
  divisors = exponents.shift.product(*exponents).map do |powers|
    primes.zip(powers).map{|prime, power| prime ** power}.inject(:*)
  end
end

house_num = 11
found_p1 = false
found_p2 = false
while not found_p1 or not found_p2
	house_num += 1
	factors = factors_of(house_num)
	if house_num%100000 == 0
		print house_num, "\n"
	end

	if not found_p1
		num_presents = factors.inject(:+)
		if num_presents >= input1
			print("Problem 1: lowest house number: #{house_num}\n")
			found_p1 = true
		end
	end

	if not found_p2
		num_presents = factors.select{|n| house_num/n <= 50}.inject(:+)
		if num_presents >= input2
			print("Problem 2: lowest house number: #{house_num}\n")
			found_p2 = true
		end
	end

#	print("#{house_num} factors: #{factors} presents: #{num_presents}\n")
end


__END__
