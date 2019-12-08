#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
	nums = l.scan(/-?\d+/).map(&:to_i)
	name = l.scan(/^(.*):.*$/)[0][0]
	[name, nums[0,4], nums[4]]
}.freeze

MAX_SPOONS = 100

print(input, "\n")

input.each {|l|
	print(l, "\n")
}

def n_spoon_of(ing_arr, nspoon)
	ing_arr.map{ |n| nspoon*n }
end

def calc_score_and_calories(ingredients, spoon_arr)
	score_arr = []
	calories = 0
	(0..ingredients.length-1).each { |n|
		act_ing = n_spoon_of(ingredients[n][1], spoon_arr[n])
		score_arr += [act_ing]
		calories += spoon_arr[n] * ingredients[n][2]
	}

	total_arr = score_arr.transpose.map {|x| x.inject(:+)}

	if total_arr.any? { |x| x<=0 }
		total_score = 0
	else
		total_score = total_arr.inject(:*)
	end

	return total_score, calories
end 

def best_ingredients(ingredients, spoon_arr)
	spoons_left = MAX_SPOONS - spoon_arr.inject(:+).to_i	# works for []
	if ingredients.length-1 == spoon_arr.length
		spoon_arr += [spoons_left]
		total_score, calories = calc_score_and_calories(ingredients, spoon_arr)

		$best_score = [$best_score, [total_score, spoon_arr]].max
		if calories == 500
			$best_score_500 = [$best_score_500, [total_score, spoon_arr]].max
		end
	else
		(0..spoons_left).each { |n|
			best_ingredients(ingredients, spoon_arr + [n])
		}
	end
end

$best_score = [-1, []]
$best_score_500 = [-1, []]

best_ingredients(input, [])
print("best score: #{$best_score}\n")
print("best score at 500 calories: #{$best_score_500}\n")



__END__
Frosting: capacity 4, durability -2, flavor 0, texture 0, calories 5
Candy: capacity 0, durability 5, flavor -1, texture 0, calories 8
Butterscotch: capacity -1, durability 0, flavor 5, texture 0, calories 6
Sugar: capacity 0, durability 0, flavor -2, texture 2, calories 1
