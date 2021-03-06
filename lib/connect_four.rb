class Player
  attr_accessor :name, :token
  def initialize(name, token)
    @name = name
    @token = token
  end
end

class ConnectFour
  attr_accessor :board
  def initialize
    @board = generate_board
    @turns = 42
  end

  def generate_board
    Array.new(6){ Array.new(7) {" "}}
  end

  def game_over?
    horizontal_win? || vertical_win? || diagonal_win? || draw?
  end

  def horizontal_win?
    board.each do |row|
      4.times do |i|
        if row[i,4] == Array.new(4,"X")  || row[i,4] == Array.new(4,"O")
          return true
        end
      end
    end
    false
  end

  def vertical_win?
    board.transpose.each do |col|
      3.times do |i|
        if col[i,4] == Array.new(4,"X")  || col[i,4] == Array.new(4,"O")
          return true
        end
      end
    end
    false
  end

  def diagonal_win?
    board.each_with_index do |row, index|
      if index <= 2
        7.times do |i|
          temp = Array.new
          4.times {|x| temp << board[index+x][i+x]}
          if temp == Array.new(4,"X") || temp == Array.new(4,"O")
            return true
          end
        end

        7.times do |i|
          temp = Array.new
          4.times {|x| temp << board[index+x][i-x]}
          if temp == Array.new(4,"X") || temp == Array.new(4,"O")
            return true
          end
        end
      end
    end
    false
  end

  def draw?
    @turns -= 1
    return true if @turns == 0
    return false
  end

  def play
    create_players
    play_turn until game_over?
    game_end_info
    play_again
  end

  def play_turn
    draw_board
    puts "#{@current_player.name} turn!"
    puts "Where do you want to drop token? (1-7)"
    input = (gets.chomp.to_i) - 1 
    until valid_input?(input)
      input = (gets.chomp.to_i) - 1 
    end
    drop_token(@current_player, input)
    draw_board
    switch_players
  end

  def play_again(input = "")
    puts "\nPlay again? (y/n)"
    input = gets.chomp.downcase until input.match?(/[yn]/)
    if input == "y"
      reset
      play
    else 
      return false
    end
  end

  def drop_token(player, column)
    if self.board[0][column] != " "
      puts "invalid move"
      return :ful
    else
      board.reverse.each do |ary|
        if ary[column] == " "
          ary[column] = player.token
          break
        end
      end
    end
  end

  def reset
    puts `clear`
    @board = generate_board
    @turns = 42
  end

  def draw_board
    puts `clear`
    border = "+---+---+---+---+---+---+---+"
    puts "+-1-+-2-+-3-+-4-+-5-+-6-+-7-+"
    board.each do |ary|
      puts border
      ary.each {|x| print "| #{x} "}
      print "|"
      puts
    end
    puts border
    puts
  end

  def create_players
    puts "Player 1 name: "
    @player1 = Player.new(gets.chomp, "X")
    puts "Player 2 name: "
    @player2 = Player.new(gets.chomp, "O")
    @current_player = @player1
  end

  def switch_players
    if @current_player == @player1
      @current_player = @player2
    else
      @current_player = @player1
    end
  end

  def valid_input?(input)
    if valid_range?(input) && !full_col(input)
      return true
    end
    return false
  end

  def full_col(input)
    if board.transpose[input][0] != " "
      puts "Col #{input+1} is full, pick another"
      return true
    end
    return false
  end

  def valid_range?(input)
    if input.between?(0,8)
      return true
    end
    puts "Please pick number from 1 to 9"
    return false
  end

  def game_end_info
    puts "Draw game" if draw?
    if @current_player.name == @player1.name
      puts "Game over, #{@player2.name} won !!!"
    else
      puts "Game over, #{@player1.name} won !!!"
    end
  end
end

ConnectFour.new.play