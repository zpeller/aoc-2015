#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
       l.scan(/-?\d+/).map(&:to_i).freeze
}

input = input[0]
key0 = 20151125

diag_num = 2
key = key0

found = false
while not found
	(1..diag_num).each {|x|
		y = diag_num-x + 1
		key = (key * 252533) % 33554393
		if [y, x] == input
			found = true
			break
		end
	}
	diag_num += 1
end
print("Problem 1 grid key: #{key}\n")
print("There's no problem 2, just click!\n")

__END__
To continue, please consult the code grid in the manual.  Enter the code at row 2981, column 3075.
