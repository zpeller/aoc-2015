#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
	l.scan(/-?\d+/).map(&:to_i).freeze
}

$boss_hp = input[0][0]
$boss_damage = input[1][0]
$boss_armor = input[2][0]

# Weapons:    Cost  Damage  Armor
shop_weapons = """Dagger        8     4       0
Shortsword   10     5       0
Warhammer    25     6       0
Longsword    40     7       0
Greataxe     74     8       0"""

# Armor:    Cost  Damage  Armor
shop_armors = """Leather      13     0       1
Chainmail    31     0       2
Splintmail   53     0       3
Bandedmail   75     0       4
Platemail   102     0       5"""

# Rings
shop_rings = """Damage+a    25     1       0
Damage+b    50     2       0
Damage+c   100     3       0
Defense+a   20     0       1
Defense+b   40     0       2
Defense+c   80     0       3
"""

def read_tools(tool)
	rv = {}
	tool.each_line.map { |l|
		tokens = l.scan(/^([^ ]*) *(\d*) *(\d*) *(\d*)$/)[0]
		rv[tokens[0]] = [tokens[1].to_i, tokens[2].to_i, tokens[3].to_i]
	}
	return rv
end

weapons = read_tools(shop_weapons)

armors = read_tools(shop_armors)
armors['Nullarmor'] = [0, 0, 0]

rings = read_tools(shop_rings)
rings['Nullring1'] = [0, 0, 0]
rings['Nullring2'] = [0, 0, 0]

tools = weapons.merge(armors).merge(rings)

#print weapons, "\n"
#print armors, "\n"
#print rings, "\n"
#print tools, "\n"

#p $boss_hp, $boss_damage, $boss_armor

$self_hp = 100

def fight(damage, armor)
	b_hp = $boss_hp
	s_hp = $self_hp
	while b_hp>0 and s_hp>0
		b_hp -= [damage - $boss_armor, 1].max
		if b_hp<=0
			return true
		end
		s_hp -= [$boss_damage - armor, 1].max
	end
	return false
end

min_cost=[100000000, []]
max_cost=[0, []]
rings.keys.combination(2) { |ring|
	armors.keys.each { |armor|
		weapons.keys.each { |weapon|
			cost = 0
			s_damage = 0
			s_armor = 0
			t1 = ring + [armor] + [weapon]
			(ring+[armor]+[weapon]).each { |tool|
				cost += tools[tool][0]
				s_damage += tools[tool][1]
				s_armor += tools[tool][2]
			}
			if fight(s_damage, s_armor)
				min_cost = [min_cost, [cost, [ring, armor, weapon]]].min
			else
				max_cost = [max_cost, [cost, [ring, armor, weapon]]].max
			end
		}
	}
}

print("Problem 1: minimal cost when win: #{min_cost}\n")
print("Problem 2: maximal cost when lose: #{max_cost}\n")


__END__
Hit Points: 104
Damage: 8
Armor: 1
