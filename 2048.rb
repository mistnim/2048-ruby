#! /usr/bin/env ruby
require 'io/console'
require 'colorize'

@board = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]] # 4x4 array of board

def color_num num
	snum = '%4.4s' % num
	retnum = ""
	case num
	when 0
		retnum = "    "
	when 2
		retnum = snum.red
	when 4
		retnum = snum.light_red
	when 8
		retnum = snum.yellow
	when 16
		retnum = snum.green
	when 32
		retnum = snum.light_green
	when 64
		retnum = snum.light_cyan
	when 128
		retnum = snum.cyan
	when 256
		retnum = snum.blue
	when 512
		retnum = snum.light_blue
	when 1024
		retnum = snum.light_magenta
	when 2048
		retnum = snum.magenta
  when 4096
    retnum = snum.light_white
	else
		abort "error"
	end
	return retnum.underline
end

def check_win
	return @board.flatten.max == 2048
end

def print_board
	puts " ___________________"
	(0..3).each{|ii|
		print '|'
		(0..3).each{|jj|
			n = @board[ii][jj]
			print color_num n
			print '|'
		}
		puts ""
	}
	puts ""
end

def new_piece
  rnd = rand 10
  if rnd == 0
    piece = 4
  else
    piece = 2
  end
	xx = rand(0..3)
	yy = rand(0..3)
	(0..3).each{|ii|
		(0..3).each{|jj|
			x1 = (xx + ii) % 4
			y1 = (yy + jj) % 4
			if @board[x1][y1] == 0
				@board[x1][y1] = piece
				return true
			end
		}
	}
	return false
end

def get_input
	input = ''
	dirs = ['w', 'a', 's', 'd']
	while not dirs.include?(input) do
		input = STDIN.getch
		if input == "q"
			abort "quit"
		end
	end
	return input
end

def shift_left line
	l2 = Array.new
	line.each do |ii|
		if not ii == 0
			l2.push ii
		end
	end
	while not l2.size == 4
		l2.push 0
	end
	return l2
end

def move_left board
	tempBoard = Marshal.load(Marshal.dump(board))
	(0..3).each{|ii|
		(0..3).each{|jj|
			(jj..2).each{|kk|
				if board[ii][kk + 1] == 0
					next
				elsif board[ii][jj] == board[ii][kk + 1]
					board[ii][jj] = board[ii][jj] * 2
					board[ii][kk + 1] = 0
				end
				break
			}
		}
		board[ii] = shift_left board[ii]
	}
	if board == tempBoard
		return false
	else
		return board
	end
end

def move_right board
	board.each{|a|a.reverse!}
	work = move_left board
	board.each{|a|a.reverse!}
	return false unless work
  board
end

def move_down board
	board = board.transpose.map &:reverse
	work = move_left board
	board = board.transpose.map &:reverse
	board = board.transpose.map &:reverse
	board = board.transpose.map &:reverse
	return false unless work
  board
end

def move_up board
	board = board.transpose.map &:reverse
	board = board.transpose.map &:reverse
	board = board.transpose.map &:reverse
	work = move_left board
	board = board.transpose.map &:reverse
	return false unless work
  board
end

def check_lose
	tempBoard = Marshal.load(Marshal.dump(@board))
	t = move_right @board
	if t == false
		t = move_left @board
		if t == false
			t = move_up @board
			if t == false
				t = move_down @board
				if t == false
					@board = Marshal.load(Marshal.dump(tempBoard))
					return true
				end
			end
		end
	end
	@board = Marshal.load(Marshal.dump(tempBoard))
	return false
end

def board_to_asp board
  board.flatten.join(', ')
end

def get_asp_input
  # File.open('input.pl', 'w') do |file|
  #   file.write board_to_asp
  # end
  idlv_path = 'idlv'
  input = "input(#{board_to_asp @board}). depth(0)."
  apply = move_left @board
  input += "after(left, #{board_to_asp apply})." if apply
  apply = move_right @board
  input += "after(right, #{board_to_asp apply})." if apply
  apply = move_up @board
  input += "after(up, #{board_to_asp apply})." if apply
  apply = move_down @board
  input += "after(down, #{board_to_asp apply})." if apply
  (`echo "#{input}" | cat - tables.pl logic.pl | #{idlv_path} --stdin applymove.py | clasp`.scan /move\((\w+)\)/)[-1][0]
end

puts "move with wasd"
2.times{ new_piece }
print_board
win = true

loop do
  puts "evaling"
  input = get_asp_input
  puts "evaled"
  dir = { 'left' => 'a', 'right' => 'd', 'up' => 'w', 'down' => 's' }[input]
  #exit if STDIN.getch == 'q'
  work = true
	case dir
	when 'a'
		apply = move_left @board
	when 'd'
		apply = move_right @board
	when 's'
		apply = move_down @board
	when 'w'
		apply = move_up @board
	end
  if apply
    @board = apply
  else
    work = false
  end

	if work
		new_piece
	end
	puts "\e[H\e[2J"
	print_board

	if check_lose
		win = false
		break
	end
end

if win
	puts "*<:-) WINNER!"
else
	puts ":-( maybe next time"
end


