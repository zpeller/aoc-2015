#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map(&:to_s).freeze

input = input[0].strip.freeze
print input

def look_and_say(line)
	nextline = ''
	prev_char = ''
	ccount = 0
	line.chars.each { |c|
		if prev_char != c
			if prev_char != ''
				nextline+= ccount.to_s + prev_char
			end
			prev_char = c
			ccount = 1
		else prev_char == c
			ccount += 1
		end
	}
	nextline += ccount.to_s + prev_char
end

line = input.strip
r40 = 0
prevlen=1
conway_no = 1.303161320880749
(1..50).each { |n|
	line = look_and_say(line)
	guessed_len = (prevlen * conway_no + 0.499999999).to_i
	print("#{n}. prevlen: #{prevlen} newlen: #{line.length} (guess: #{guessed_len} ratio: #{line.length/prevlen.to_f}\n")
	if n == 40
		r40 = line.length
	end
	prevlen = line.length
#	puts line
}

print("1. (40) string length: #{r40}\n")
print("2. (50) string length: #{line.length}\n")



__END__
1113222113
