require 'colorize'
require_relative 'board'
require_relative 'cursor'
require 'byebug'

class Display
  attr_reader :cursor

  def initialize
    @cursor = Cursor.new([0,0], Board.new)
  end

  def render

    self.cursor.board.board.each_with_index do |row, row_idx|
      row.each_with_index do |col, col_idx|
        pos = row_idx, col_idx
        #for now
        if self.cursor.board[[row_idx, col_idx]].class.superclass == Piece ||
          self.cursor.board[[row_idx, col_idx]].class == Piece
          if self.cursor.cursor_pos == [row_idx, col_idx]
            print self.cursor.board[[row_idx, col_idx]].name.to_s[0].capitalize.colorize(:red)
          else
            print self.cursor.board[[row_idx, col_idx]].name.to_s[0].capitalize.colorize(:blue)
          end
        elsif self.cursor.board[[row_idx, col_idx]] == nil
          if self.cursor.cursor_pos == [row_idx, col_idx]
            print "_".colorize(:red)
          else
            print "_".colorize(:blue)
          end

        end
      end
      print "\n"
    end


  end

end

d = Display.new
until 1 > 2
  system("clear")
  d.render
  # d.cursor.board.move_piece([0,0], [2,0])
  d.cursor.get_input #will give us the position we want to go to 
  d.render
end
