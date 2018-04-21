# STDOUT is not put immediately without a code below
STDOUT.sync = true

class HandOfCards
  def initialize
    @@deck = Array.new
    @hand = Array.new
  end

  def put_deck
    print @@deck
  end

  attr_reader :deck, :hand

  def refresh_hand
    @hand = Array.new
  end

  def draw_a_card
    card = @@deck.sample
    @@deck.delete_at(@@deck.find_index(card))
    @hand.push(card)
  end

  def evaluate_hand
    total = [0,0] 
    @hand.each{|card|
      if card > 10 then
        total.map! {|value| value += 10 }
      elsif card == 1 then
        total[0] += card
        total[1] += (total[1] + 11) <= BJ ? 11 : card
      else
        total.map! {|value| value += card }
      end
    }

    if total[0] > BJ then
      return 'Bust'
    elsif total.find_index(BJ) != nil then
      return [BJ]
    elsif total[0] == total[1] or total[1] > BJ then
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
  def deck
    @@deck
  end

  def initializer_deck(deck_number)
    card_list = [*(1..13)]
    @@deck = card_list * 4 * deck_number
  end

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

BJ = 21
HIT = 'h'
STAND = 's'

deck_number = 6

tip = 100

puts '----------'
puts 'BLACK JACK'
puts '----------'

player = Player.new()
dealer = Dealer.new()
dealer.initializer_deck(deck_number)

loop do
  if tip < 1 then
    puts 'Bankrupt!'
    break
  elsif dealer.deck.size < 100 then
    dealer.initializer_deck(deck_number)
  end

  puts
  puts 'Next Game [Enter]'
  gets
  
  puts 'Your tip: ' + tip.to_s
  puts 'How much do you want to bet?'

  while (input = gets.to_i) < 1 or input > tip
    puts 'Please input again.'
  end

  player.refresh_hand
  dealer.refresh_hand

  player.bet = input

  player.draw_a_card
  dealer.draw_a_card
  player.draw_a_card
  dealer.draw_a_card
  
  print 'dealer hand: '
  if dealer.evaluate_hand.max == BJ then
    puts dealer.show_hand  
    puts 'Dealer Black Jack!'
  else
    puts dealer.show_first_hand
  end

  print 'player hand: '
  puts player.show_hand
  puts 'Player Black Jack!' if player.evaluate_hand.max == BJ

  if dealer.evaluate_hand.max == BJ && player.evaluate_hand.max == BJ then
    puts 'Draw'
    next  
  elsif dealer.evaluate_hand.max == BJ then
    puts 'Dealer wins...'
    tip -= player.bet
    next
  elsif player.evaluate_hand.max == BJ then
    puts 'Player wins!'
    tip += player.win_bj
    next
  end
  
  puts 'player total is ' + player.evaluate_hand.to_s
  puts

  loop do
    puts 'Hit[h] or Stand[s]?'
    input = gets.chomp
    if input == HIT then
      player.draw_a_card
      print 'dealer hand: '
      puts dealer.show_first_hand
      print 'player hand: '
      puts player.show_hand
      puts 'player total is ' + player.evaluate_hand.to_s
      puts
      if player.evaluate_hand == 'Bust' then
        puts 'Player Bust!'
        puts 'Dealer wins...'
        tip -= player.bet
        break
      end
      break if player.evaluate_hand.max == BJ
      next
    end
    break if input == STAND
    puts 'Please select again.'
  end

  next if player.evaluate_hand == 'Bust'

  loop do
    print 'dealer hand: '
    puts dealer.show_hand

    if dealer.evaluate_hand == 'Bust' then
      puts 'Dealer Bust!'
      puts 'Player wins!'
      tip += player.win
      break
    elsif dealer.evaluate_hand.max > 16 then
      puts 'dealer total is ' + dealer.evaluate_hand.max.to_s
      if player.evaluate_hand.max > dealer.evaluate_hand.max then
        puts 'Player wins!'
        tip += player.win
      elsif player.evaluate_hand.max < dealer.evaluate_hand.max then
        puts 'Dealer wins...'
        tip -= player.bet
      else
        puts 'Draw'
      end
      break
    end

    dealer.draw_a_card
  end
end
