#!/usr/bin/ruby

medicine_molecule='CRnCaCaCaSiRnBPTiMgArSiRnSiRnMgArSiRnCaFArTiTiBSiThFYCaFArCaCaSiThCaPBSiThSiThCaCaPTiRnPBSiThRnFArArCaCaSiThCaSiThSiRnMgArCaPTiBPRnFArSiThCaSiRnFArBCaSiRnCaPRnFArPMgYCaFArCaPTiTiTiBPBSiThCaPTiBPBSiRnFArBPBSiRnCaFArBPRnSiRnFArRnSiRnBFArCaFArCaCaCaSiThSiThCaCaPBPTiTiRnFArCaPTiBSiAlArPBCaCaCaCaCaSiRnMgArCaSiThFArThCaSiThCaSiRnCaFYCaSiRnFYFArFArCaSiRnFYFArCaSiRnBPMgArSiThPRnFArCaSiRnFArTiRnSiRnFYFArCaSiRnBFArCaSiRnTiMgArSiThCaSiThCaFArPRnFArSiRnFArTiTiTiTiBCaCaSiRnCaCaFYFArSiThCaPTiBPTiBCaSiThSiRnMgArCaF'
medicine_molecule1='CRnCaCaCaSiRnBPTiMgArSiRnSiRnMgArSiRnCaFArTiTiBSiThFYCaFArCaCaSiThCaPBSiThSiThCaCaPTiRnPBSiThRnFArArCaCaSiThCaSiThSiRnMgArCaPTiBPRnFArSiThCaSiRnFArBCaSiRnCaPRnFArPMgYCaFArCaPTiTiTiBPBSiThCaPTiBPBSiRnFArBPBSiRnCaFArBPRnSiRnFArRnSiRnBFArCaFArCaCaCaSiThSiThCaCaPBPTiTiRnFAr'
medicine_molecule2='CaPTiBSiAlArPBCaCaCaCaCaSiRnMgArCaSiThFArThCaSiThCaSiRnCaFYCaSiRnFYFArFArCaSiRnFYFArCaSiRnBPMgArSiThPRnFArCaSiRnFArTiRnSiRnFYFArCaSiRnBFArCaSiRnTiMgArSiThCaSiThCaFArPRnFArSiRnFArTiTiTiTiBCaCaSiRnCaCaFYFArSiThCaPTiBPTiBCaSiThSiRnMgArCaF'

# medicine_molecule = 'HOHOHO'
# medicine_molecule = 'CRnPRnCaRnFArArFArThCaPTiBF'

start_pattern = 'e'

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
	tokens = l.scan(/^(.*) => (.*)$/)[0].freeze
	[tokens[0], tokens[1]]
}.freeze

print(input, "\n\n")

$replacements = Hash.new([])
$rev_replacements = {}

scan_patterns = []
input.each {|key, value|
	$replacements[key] += [value]
	$rev_replacements[value] = key
	scan_patterns += [value]
}

print $replacements, "\n\n"
print $rev_replacements, "\n\n"

$scan_re = Regexp.new('('+scan_patterns.uniq.sort_by(&:length).reverse.join('|')+')')
print scan_patterns, "\n", $scan_re, "\n"

def calibrate(init_pattern, replacements)
	num_distinct_molecules = 0
	result_molecules = []

	pattern_chunks = init_pattern.scan(/[A-Z][a-z]?/)
	pattern_chunks.each_with_index { |elem, idx|
		pattern_start = (idx>0) ? (pattern_chunks[0..idx-1].join) : ''
		pattern_end = (idx<pattern_chunks.length-1) ? (pattern_chunks[idx+1..-1].join) : ''
		replacements[elem].each { |r|
			result_molecules += [ pattern_start + r + pattern_end ]
		}
	}
	return result_molecules.uniq.length
end

print("Problem 1 calibration result: #{calibrate(medicine_molecule, $replacements)}\n")

#def find_and_replace_longest_pattern(molecule)
##	longest_pattern = molecule.scan($scan_re).map {|x| x[0]}.max_by(&:length)
#	longest_pattern = molecule.scan($scan_re).flatten.max_by(&:length)
#	longest_pattern_pos = molecule.index(longest_pattern)
#	print longest_pattern,': ', longest_pattern_pos, "\n"
#	new_molecule = molecule[0,longest_pattern_pos] + $rev_replacements[longest_pattern] + molecule[longest_pattern_pos+longest_pattern.length..-1]
#end
#
#test_molecule = medicine_molecule
#print test_molecule, "\n"
#(1..300).each { |n|
#	test_molecule = find_and_replace_longest_pattern(test_molecule)
#	print("#{n}. #{test_molecule}\n")
#}

test_molecule = medicine_molecule
print test_molecule, "\n"
$iterations = 0
#$mlen = [10000, 'a']

def test_patterns(molecule, pattern_list, level)
#	if molecule =~ /^..Ar/
#		return
#	end
#	molecule.scan($scan_re).flatten.sort_by(&:length).reverse.each { |pattern|
	molecule.enum_for(:scan, $scan_re).map{ |pat| [Regexp.last_match.begin(0), pat[0]] }.each { |pattern_pos, pattern|
#		print("pos: #{pattern_pos} pat: #{pattern}\n")
		$iterations += 1
		if $iterations % 10000000 == 0
			print("#{$iterations} Level #{level} molecule: #{molecule}\n")
		end

#		pattern_pos = molecule.index(pattern)
		new_molecule = molecule[0,pattern_pos] + $rev_replacements[pattern] + molecule[pattern_pos+pattern.length..-1]
		if new_molecule == 'e' 
			print("\n\nProblem 2 steps: #{level} pattern: #{pattern_list}\n\n\n")
		end
#		$mlen = [$mlen, [new_molecule.length, new_molecule]].min

		test_patterns(new_molecule, pattern_list + [pattern], level+1)
	}
end

test_patterns(test_molecule, [], 1)


__END__
Al => ThF
Al => ThRnFAr
B => BCa
B => TiB
B => TiRnFAr
Ca => CaCa
Ca => PB
Ca => PRnFAr
Ca => SiRnFYFAr
Ca => SiRnMgAr
Ca => SiTh
F => CaF
F => PMg
F => SiAl
H => CRnAlAr
H => CRnFYFYFAr
H => CRnFYMgAr
H => CRnMgYFAr
H => HCa
H => NRnFYFAr
H => NRnMgAr
H => NTh
H => OB
H => ORnFAr
Mg => BF
Mg => TiMg
N => CRnFAr
N => HSi
O => CRnFYFAr
O => CRnMgAr
O => HP
O => NRnFAr
O => OTi
P => CaP
P => PTi
P => SiRnFAr
Si => CaSi
Th => ThCa
Ti => BP
Ti => TiTi
e => HF
e => NAl
e => OMg
