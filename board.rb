require_relative 'piece'
require 'byebug'

class Board
attr_reader :board
  def initialize
    @board = Array.new(8) {Array.new(8)}
    populate_board
  end

  #we added these [] methods but I don't think we're using them right
  def [](pos)
   row, col = pos
   @board[row][col]
 end

 def []=(pos, piece)
   row, col = pos
   @board[row][col] = piece
 end

  def populate_board
    #initial positions indicate team color
    @board.each_with_index do |row, row_idx|
      if row_idx == 0 || row_idx == 1
        color = "black"
      end
      if row_idx == 6 || row_idx == 7
        color = "white"
      end
      #generate pieces depending on location
      row.each_index do |col_idx|
        if row_idx == 1 || row_idx == 6
          self[[row_idx, col_idx]] = Pawn.new("pawn", [row_idx, col_idx], color, self)
        end
        if row_idx == 0 || row_idx == 7
            if col_idx == 0 || col_idx == 7

              self[[row_idx, col_idx]] = Rook.new("rook", [row_idx, col_idx], color, self)
            end
            if col_idx == 1 || col_idx == 6
              self[[row_idx, col_idx]] = Knight.new("knight", [row_idx, col_idx], color, self)
            end
            if col_idx == 2 || col_idx == 5
              self[[row_idx, col_idx]] = Bishop.new("bishop", [row_idx, col_idx], color, self)
            end
            self[[row_idx, col_idx]] = Queen.new("queen", [row_idx, col_idx], color, self) if col_idx == 3
            self[[row_idx, col_idx]] = King.new("king", [row_idx, col_idx], color, self) if col_idx == 4
        end
        # if row_idx > 1 && row_idx < 6
        #   self[[row_idx, col_idx]] = NullPiece.new("null", )
        #
        # end
      end
    end
  end

  def move_piece(start_pos, end_pos)
    if self[start_pos] == nil
      raise ArgumentError.new("No piece there")
    end
    #get current piece
    current_piece = self[start_pos]
    #reset current's position attribute
    current_piece.position = end_pos
    #move the piece
    self[end_pos] = current_piece
    #set previous spot to empty
    self[start_pos] = nil
  end
  #skipped end_pos error

  def in_check?(color)
    king_position = nil

    #search for king
    @board.each_with_index do |row, row_idx|
      row.each_with_index do |col, col_idx|
        if self[[row_idx, col_idx]].class == King && self[[row_idx, col_idx]].color == color
          king_position = [row_idx, col_idx]
        end
      end
    end
    #search for pieces who include king's position as valid move 
    @board.each_with_index do |row, row_idx|
      row.each_with_index do |col, col_idx|
        if self[[row_idx, col_idx]] != nil
          return true if self[[row_idx, col_idx]].moves.include?(king_position)
        end
      end
    end
    false
  end

  def self.checkmate(color)
    # if self.class.in_check?(color) &&
  end

  def in_bounds?(position)
    if position[0] < 0 || position[0] > 7 || position[1] < 0 || position[1] > 7
      return false
    end
    true
  end


end
