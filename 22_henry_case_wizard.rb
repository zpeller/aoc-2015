#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
	l.scan(/-?\d+/).map(&:to_i).freeze
}

$boss_hp = input[0][0]
$boss_damage = input[1][0]

$spells = {}

#class Spell
#	def initialize(name, cost, instant_damage, instant_heal, rec_damage, rec_armor, rec_mana, turns)
#		@name, @cost, @instant_damage, @instant_heal, @rec_damage, @rec_armor, @rec_mana, @turns = name, cost, instant_damage, instant_heal, rec_damage, rec_armor, rec_mana, turns
#	end
#end

class Spell
	attr_reader :name
	attr_reader :cost
	attr_reader :instant_damage
	attr_reader :instant_heal
	attr_reader :rec_damage
	attr_reader :rec_armor
	attr_reader :rec_mana
	attr_reader :turns

	def initialize(name, cost, options = Hash.new(0) )
		@name, @cost = name, cost
		@instant_damage = options.fetch(:instant_damage, 0)
		@instant_heal = options.fetch(:instant_heal, 0)
	   	@rec_damage = options.fetch(:rec_damage, 0)
	   	@rec_armor = options.fetch(:rec_armor, 0)
	   	@rec_mana = options.fetch(:rec_mana, 0)
	   	@turns = options.fetch(:turns, 0)
#		instant_damage, instant_heal, rec_damage, rec_armor, rec_mana, turns)
	end
end

#Magic Missile costs 53 mana. It instantly does 4 damage.
#Drain costs 73 mana. It instantly does 2 damage and heals you for 2 hit points.
#Shield costs 113 mana. It starts an effect that lasts for 6 turns. While it is active, your armor is increased by 7.
#Poison costs 173 mana. It starts an effect that lasts for 6 turns. At the start of each turn while it is active, it deals the boss 3 damage.
#Recharge costs 229 mana. It starts an effect that lasts for 5 turns. At the start of each turn while it is active, it gives you 101 new mana.

def init_spells() 
	$spells["Recharge"] = Spell.new("Recharge", 229, {rec_mana:101, turns:5} )
	$spells["Shield"] = Spell.new("Shield", 113, {rec_armor:7, turns:6} )
	$spells["Drain"] = Spell.new("Drain", 73, {instant_damage:2, instant_heal:2} )
	$spells["Poison"] = Spell.new("Poison", 173, {rec_damage:3, turns:6} )
	$spells["Magic Missile"] = Spell.new("Magic Missile", 53, {instant_damage:4} )
end

def store_min_mana_spent(mana_spent, spell_list)
	$min_mana_spent = [$min_mana_spent, [mana_spent, spell_list]].min
#	print("Min mana: #{$min_mana_spent}\n")
end

def process_timed_spells (active_spell_turns, user_hp, user_mana, boss_hp)
	armor = 0
	active_spell_turns.keys.each { |spell_name|
		if $spells[spell_name].rec_damage > 0
			boss_hp -= $spells[spell_name].rec_damage
		elsif $spells[spell_name].rec_mana > 0
			user_mana += $spells[spell_name].rec_mana
		elsif $spells[spell_name].rec_armor > 0
			armor += $spells[spell_name].rec_armor
		end

		active_spell_turns[spell_name] -= 1
		if active_spell_turns[spell_name] == 0
			active_spell_turns.delete(spell_name)
		end
	}
	return user_hp, user_mana, boss_hp, armor
end

def process_instant_spells(spell, user_hp, user_mana, boss_hp)
		user_mana -= spell.cost
		user_hp += spell.instant_heal
		boss_hp -= spell.instant_damage
	return user_hp, user_mana, boss_hp
end

def dump_stats(user_hp, user_mana, boss_hp, active_spell_turns, mana_spent, spell_list)
	return
	print("uhp: #{user_hp} um: #{user_mana}/#{mana_spent} bhp: #{boss_hp}\nas: #{active_spell_turns}\nsp: #{spell_list}\n\n")
end

def start_user_round(user_hp, user_mana, boss_hp, active_spell_turns, mana_spent, spell_list)
	active_spell_turns = active_spell_turns.dup

	if $hard_mode
		user_hp -= 1
		if user_hp <=0; return; end
	end

#	print("Begin user rd\n")
	dump_stats(user_hp, user_mana, boss_hp, active_spell_turns, mana_spent, spell_list)

	user_hp, user_mana, boss_hp, armor = process_timed_spells(active_spell_turns, user_hp, user_mana, boss_hp)
	if boss_hp <=0; store_min_mana_spent(mana_spent, spell_list); return; end

#	choose next spell
	$spells.each { |key, spell|
#	name, spell = $test_spells.shift

		if spell.cost > user_mana or active_spell_turns.key?(spell.name)
#			abort("nem jo")
			next
		end

#		cast spell
		cast_spell(spell, user_hp, user_mana, boss_hp, active_spell_turns, mana_spent, spell_list)
	}
end

def cast_spell(spell, user_hp, user_mana, boss_hp, active_spell_turns, mana_spent, spell_list)
	active_spell_turns = active_spell_turns.dup

	mana_spent += spell.cost
	if mana_spent > $min_mana_spent[0]
		return
	end

	spell_list += [spell.name]

	user_hp, user_mana, boss_hp = process_instant_spells(spell, user_hp, user_mana, boss_hp)
	if boss_hp <=0; store_min_mana_spent(mana_spent, spell_list+[spell.name]); return; end

	if spell.rec_damage > 0 or spell.rec_armor > 0 or spell.rec_mana > 0
		active_spell_turns[spell.name] = spell.turns
	end
#	print("End user rd\n")
	dump_stats(user_hp, user_mana, boss_hp, active_spell_turns, mana_spent, spell_list)


	start_boss_round(user_hp, user_mana, boss_hp, active_spell_turns, mana_spent, spell_list)
end

def start_boss_round(user_hp, user_mana, boss_hp, active_spell_turns, mana_spent, spell_list)
	active_spell_turns = active_spell_turns.dup

#	print("Begin boss rd\n")
	dump_stats(user_hp, user_mana, boss_hp, active_spell_turns, mana_spent, spell_list)

	user_hp, user_mana, boss_hp, armor = process_timed_spells(active_spell_turns, user_hp, user_mana, boss_hp)
	if boss_hp <=0; store_min_mana_spent(mana_spent, spell_list); return; end

	user_hp -= [$boss_damage-armor, 1].max

#	print("End boss rd\n")
	dump_stats(user_hp, user_mana, boss_hp, active_spell_turns, mana_spent, spell_list)

	if user_hp <=0; return; end

	start_user_round(user_hp, user_mana, boss_hp, active_spell_turns, mana_spent, spell_list)
end

$self_hp = 50
$self_mana = 500

init_spells()
$spells.freeze
$test_spells = $spells.dup

#print $spells, "\n"
#puts

$min_mana_spent = [10000000, []]

# XXX override!!!!!
#$boss_damage = 8

#start_user_round(10, 250, 14, {}, 0, [])
#print("Min mana spent: #{$min_mana_spent}\n")

$min_mana_spent = [10000000, []]
$hard_mode = false
start_user_round($self_hp, $self_mana, $boss_hp, {}, 0, [])
print("Problem 1 min mana spent: #{$min_mana_spent}\n")

$min_mana_spent = [10000000, []]
$hard_mode = true
start_user_round($self_hp, $self_mana, $boss_hp, {}, 0, [])
print("Problem 2 min mana spent: #{$min_mana_spent}\n")

__END__
Hit Points: 51
Damage: 9
