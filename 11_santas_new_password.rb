#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map(&:to_s).freeze
input = input[0].strip.freeze

print(input, "\n", input.length, "\n")

def inc_char(c)
	nchar = (c.ord+1).chr
	return (nchar.ord+1).chr if nchar =~ /[iol]/
	return nchar
end

# XXX consider using string.next (must handle missing [iol] check!)
def next_password(passwd)
	pwlen = passwd.length
	zpos = (passwd =~ /(z+)$/)
	if zpos
		lcpos = zpos - 1
	else
		lcpos = pwlen - 1
	end
	chchar = inc_char(passwd[lcpos])
	return passwd[0, lcpos] + chchar + "a" * (pwlen-lcpos-1)
end

def next_password_2(passwd)
	passwd.next
end

def next_password_3(passwd)
	next_passwd = passwd.next
	while next_passwd =~ /[iol]/
		next_passwd = next_passwd.next
	end
	return next_passwd
end

def gen_abc_re_match_string()
	re_matcher = '('
	[*'a'..'f', *'p'..'w'].each { |c|
		re_matcher += c+inc_char(c) + inc_char(inc_char(c)) + '|'
	}
	re_matcher += 'xyz)'
end

def valid_pw?(passwd)
	passwd =~ $abc_re_match and passwd.scan(/([a-z])\1/).uniq.length >= 2
end

$abc_re_match = Regexp.new(gen_abc_re_match_string())
# puts gen_abc_re_match_string()

passwd = input
while not valid_pw?(passwd)
	passwd = next_password(passwd)
end

print("Password 1: #{passwd}\n")

passwd = next_password(passwd)
while not valid_pw?(passwd)
	passwd = next_password(passwd)
end

print("Password 2: #{passwd}\n")


__END__
vzbxkghb
