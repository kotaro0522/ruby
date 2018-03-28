# STDOUT is not put immediately without a code below
STDOUT.sync = true

def initializer_deck(deck_number)
	card_list = [*(1..13)]
	deck = card_list * 4 * deck_number
	return deck
end

class HandOfCards
	def initialize(deck)
		@deck = deck
	end

	def show_deck
		puts @deck
	end
end

def deal_card(deck)
	card = deck.sample
	deck.delete_at(deck.find_index(card))
	return card
end

def evaluate_hand(hand)
	total = [0,0] 
	hand.each{|card|
		if card > 10 then
			total[0] += 10
			total[1] += 10
		elsif card == 1 then
			total[0] += card
			if total[1] + 11 < 22 then
				total[1] += 11
			else
				total[1] += card
			end
		else
			total[0] += card
			total[1] += card
		end
	}
	if total[0] > 21 then
		return 'Bust'
	elsif total.find_index(21) != nil then
		return 'BJ'
	elsif total[0] == total[1] || total[1] > 21 then
		return [total[0]]
	else
		return total
	end
end

def replace_picture(hand)
	print '[' 
	hand.map {|card|
		case card
		when 1 then
			print 'A, '
		when 11 then
			print 'J, '
		when 12 then
			print 'Q, '
		when 13 then
			print 'K, '
		else
			print card.to_s + ', '
		end
	}
	print ']'
end

deck_number = 3
deck = initializer_deck(deck_number)

tip = 100
puts '----------'
puts 'BLACK JACK'
puts '----------'

loop do
	if tip < 1 then
		puts 'Bankrupt!'
		break
	elsif deck.size < 100 then
		deck = initializer_deck(deck_number)
	end

	puts
	puts 'Next Game [Enter]'
	gets

	puts 'Your tip: ' + tip.to_s
	puts 'How much do you want to bet?'

	while (input = gets.to_i) < 1 || input > tip
		puts 'Please input again.'
	end

	bet = input
	tip -= bet
	
	player_hand = Array.new
	player_hand.push(deal_card(deck))
	dealer_hand = Array.new
	dealer_hand.push(deal_card(deck))

	player_hand.push(deal_card(deck))
	dealer_hand.push(deal_card(deck))
	
	player_hand_total = evaluate_hand(player_hand)
	dealer_hand_total = evaluate_hand(dealer_hand)

	
	if dealer_hand_total == 'BJ' then
		print 'dealer hand: '
		puts replace_picture(dealer_hand)	
		puts 'Dealer Black Jack!'
	else
		print 'dealer hand: '
		puts replace_picture([dealer_hand[0], '?'])
	end

	print 'player hand: '
	puts replace_picture(player_hand)

	if player_hand_total == 'BJ' then
		puts 'Player Black Jack!'
	end

	if dealer_hand_total == 'BJ' && player_hand_total == 'BJ' then
		puts 'Draw'
		tip += bet
		next	
	elsif dealer_hand_total == 'BJ' then
		puts 'Dealer wins...'
		next
	elsif player_hand_total == 'BJ' then
		puts 'Player wins!'
		tip += (bet * 2.5).floor
		next
	end
	
	puts 'player total is ' + player_hand_total.to_s
	puts

	loop do
		puts 'Hit[h] or Stand[s]?'
		input = gets.chomp
		if input == 'h' then
			player_hand.push(deal_card(deck))
			player_hand_total = evaluate_hand(player_hand)
			if player_hand_total == 'BJ' then
				print 'player hand: '
				puts replace_picture(player_hand)
				puts 'Player Black Jack!'
				puts 'Player wins!'
				tip += bet * 2
				break
			elsif player_hand_total == 'Bust' then
				print 'player hand: '
				puts replace_picture(player_hand)
				puts 'Player Bust!'
				puts 'Dealer wins...'
				break
			end
			print 'dealer hand: '
			puts replace_picture([dealer_hand[0], '?'])
			print 'player hand: '
			puts replace_picture(player_hand)
			puts 'player total is ' + player_hand_total.to_s
			puts
		elsif input == 's' then
			print 'dealer hand: '
			puts replace_picture(dealer_hand)
			loop do
				if dealer_hand_total == 'BJ' then
					puts 'Dealer Black Jack!'
					puts 'Dealer wins...'
					break
				elsif dealer_hand_total == 'Bust' then
					puts 'Dealer Bust!'
					puts 'Player wins!'
					tip += bet * 2
					break
				else
					if dealer_hand_total[-1] > 16 then
						puts 'dealer total is ' + dealer_hand_total[-1].to_s
						if player_hand_total[-1] > dealer_hand_total[-1] then
							puts 'Player wins!'
							tip += bet * 2
						elsif player_hand_total[-1] < dealer_hand_total[-1] then
							puts 'Dealer wins...'
						else
							puts 'Draw'
							tip += bet
						end
						break
					end
				end
				dealer_hand.push(deal_card(deck))
				print 'dealer hand: '
				puts replace_picture(dealer_hand)
				dealer_hand_total = evaluate_hand(dealer_hand)
			end
			break
		else
			puts 'Please select again.'
		end
	end
end