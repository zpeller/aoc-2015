#!/usr/bin/ruby

require 'set'
require 'digest'

input = (ARGV.empty? ? DATA : ARGF).each_line.map(&:to_s).freeze

#puts input

secret_key = input[0].strip

decimal = 0
md5hash = 'xxxxxxx'

while md5hash[0, 5] != '00000'
	decimal += 1
	md5string = secret_key + decimal.to_s
	md5hash = Digest::MD5.hexdigest(md5string)
end

print("5 zero decimal: #{decimal} md5string: #{md5string} md5hash: #{md5hash}\n")
	
while md5hash[0, 6] != '000000'
	decimal += 1
	md5string = secret_key + decimal.to_s
	md5hash = Digest::MD5.hexdigest(md5string)
end

print("6 zero decimal: #{decimal} md5string: #{md5string} md5hash: #{md5hash}\n")



__END__
yzbqklnj
