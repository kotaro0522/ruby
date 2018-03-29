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
		@hand = Array.new
	end

	attr_reader :deck, :hand

	def draw_a_card
		card = @deck.sample
		@deck.delete_at(@deck.find_index(card))
		@hand.push(card)
	end

	def evaluate_hand
		total = [0,0] 
		@hand.each{|card|
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
	
	def show_hand(hand=@hand)
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

end

class Dealer < HandOfCards
	def show_first_hand
		show_hand([@hand[0], '?'])
	end
end

class Player < HandOfCards
	attr_accessor :bet

	def win
		return @bet
	end

	def win_bj
		return (@bet * 1.5).floor
	end
end	

deck_number = 6
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

	player = Player.new(deck)
	dealer = Dealer.new(deck)

	player.bet = input

	player.draw_a_card
	dealer.draw_a_card
	player.draw_a_card
	dealer.draw_a_card
	
	if dealer.evaluate_hand == 'BJ' then
		print 'dealer hand: '
		puts dealer.show_hand	
		puts 'Dealer Black Jack!'
	else
		print 'dealer hand: '
		puts dealer.show_first_hand
	end

	print 'player hand: '
	puts player.show_hand

	if player.evaluate_hand == 'BJ' then
		puts 'Player Black Jack!'
	end

	if dealer.evaluate_hand == 'BJ' && player.evaluate_hand == 'BJ' then
		puts 'Draw'
		next	
	elsif dealer.evaluate_hand == 'BJ' then
		puts 'Dealer wins...'
		tip -= player.bet
		next
	elsif player.evaluate_hand == 'BJ' then
		puts 'Player wins!'
		tip += player.win_bj
		next
	end
	
	puts 'player total is ' + player.evaluate_hand.to_s
	puts

	loop do
		puts 'Hit[h] or Stand[s]?'
		input = gets.chomp
		if input == 'h' then
			player.draw_a_card
			if player.evaluate_hand == 'BJ' then
				print 'player hand: '
				puts player.show_hand
				puts 'Player Black Jack!'
				puts 'Player wins!'
				tip += player.win
				break
			elsif player.evaluate_hand == 'Bust' then
				print 'player hand: '
				puts player.show_hand
				puts 'Player Bust!'
				puts 'Dealer wins...'
				tip -= player.bet
				break
			end
			print 'dealer hand: '
			puts dealer.show_first_hand
			print 'player hand: '
			puts player.show_hand
			puts 'player total is ' + player.evaluate_hand.to_s
			puts
		elsif input == 's' then
			print 'dealer hand: '
			puts dealer.show_hand
			loop do
				if dealer.evaluate_hand == 'BJ' then
					puts 'Dealer Black Jack!'
					puts 'Dealer wins...'
					tip -= player.bet
					break
				elsif dealer.evaluate_hand == 'Bust' then
					puts 'Dealer Bust!'
					puts 'Player wins!'
					tip += player.win
					break
				else
					if dealer.evaluate_hand[-1] > 16 then
						puts 'dealer total is ' + dealer.evaluate_hand[-1].to_s
						if player.evaluate_hand[-1] > dealer.evaluate_hand[-1] then
							puts 'Player wins!'
							tip += player.win
						elsif player.evaluate_hand[-1] < dealer.evaluate_hand[-1] then
							puts 'Dealer wins...'
							tip -= player.bet
						else
							puts 'Draw'
						end
						break
					end
				end
				dealer.draw_a_card
				print 'dealer hand: '
				puts dealer.show_hand
			end
			break
		else
			puts 'Please select again.'
		end
	end
end
