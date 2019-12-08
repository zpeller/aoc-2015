#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
#	l.scan(/-?\d+/).map(&:to_i).freeze
	if l =~ /,/
		tokens = l.scan(/^(...) (.), ([+-]?\d+)$/)[0].freeze
		[tokens[0], tokens[1], tokens[2]]
	else
		tokens = l.scan(/^(...) (.*)$/)[0].freeze
		[tokens[0], tokens[1]]
	end
}.freeze

#print(input, "\n")

#input.each {|l|
#	print(l, "\n")
#}

def run_program(input, rega)
	instr_ptr = 0
	cnt = -1
	regs = {"a"=>rega, "b"=>0}
	while instr_ptr>=0 and instr_ptr<input.length
		instr = input[instr_ptr][0]
		arg1 = input[instr_ptr][1]
		cnt += 1
#		print("#{cnt} #{instr_ptr} i: #{instr} a1: #{arg1} #{regs}\n")

		case instr
		when 'hlf'
			regs[arg1] /= 2
		when 'tpl'
			regs[arg1] *= 3
		when 'inc'
			regs[arg1] += 1
		when 'jmp'
			instr_ptr += arg1.to_i
			next
		when 'jie'
			if regs[arg1]%2 == 0
				arg2 = input[instr_ptr][2]
				instr_ptr += arg2.to_i
				next
			end
		when 'jio'
			if regs[arg1] == 1
				arg2 = input[instr_ptr][2]
				instr_ptr += arg2.to_i
				next
			end
		end
		instr_ptr += 1
	end
	return regs["b"]
end


print("Problem 1 reg b: " + run_program(input, 0).to_s + "\n")
print("Problem 2 reg b: " + run_program(input, 1).to_s + "\n")


__END__
jio a, +16
inc a
inc a
tpl a
tpl a
tpl a
inc a
inc a
tpl a
inc a
inc a
tpl a
tpl a
tpl a
inc a
jmp +23
tpl a
inc a
inc a
tpl a
inc a
inc a
tpl a
tpl a
inc a
inc a
tpl a
inc a
tpl a
inc a
tpl a
inc a
inc a
tpl a
inc a
tpl a
tpl a
inc a
jio a, +8
inc b
jie a, +4
tpl a
inc a
jmp +2
hlf a
jmp -7
