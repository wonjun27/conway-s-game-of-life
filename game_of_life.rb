# Conway's Game of Life
#
# Any live cell with fewer than two live neighbours dies, as if caused by under-population.
# Any live cell with two or three live neighbours lives on to the next generation.
# Any live cell with more than three live neighbours dies, as if by overcrowding.
# Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
#
# Source: http://en.wikipedia.org/wiki/Conway's_Game_of_Life

class Game
  def initialize(numRows = 15, numCols = 15, numSteps = 10)
    @board = Board.new(numRows, numCols)
    @num_steps = numSteps
  end

  def play!
    (1..@num_steps).each do
      update!
      render
    end
  end

  def update!
  	@board.update!
  end

  def render
  	sleep(1)
    system('clear')
  	puts @board.render
  end
end

class Board
  def initialize(numRows, numCols)
    @numRows = numRows
	@numCols = numCols

	@cells = Array.new(numRows) {
      		   Array.new(numCols) {
      		     Cell.new
      		   }
      		 }
  end

  def update!
  	# before applying the rules of the game, update the count of neighbors for each cell
    @cells.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        cell.count_neighbours = count_live_neighbours(y, x)
      end
    end

    # then apply the rules
    @cells.each do |row|	
      row.each do |cell|
        if cell.is_alive	
	      if cell.count_neighbours < 2
	  	    # Any live cell with fewer than two live neighbours dies, as if caused by under-population.
		    cell.is_alive = false
	      elsif cell.count_neighbours > 3
	  	    # Any live cell with more than three live neighbours dies, as if by overcrowding.
		    cell.is_alive = false
	      end
          # Any live cell with two or three live neighbours lives on to the next generation.
        else
          # Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
          if cell.count_neighbours == 3
		    cell.is_alive = true
          end
	    end
	  end	
    end
  end

  def render
  	@cells.map { |row| row.join }.join("\n")
  end

  def count_live_neighbours(y, x)
    count = 0

    if y > 0 and x < (@numCols - 1)
      neighbor = @cells[y - 1][x + 1]
      count += 1 if neighbor.is_alive
    end

	if y < (@numRows - 1) and x < (@numCols - 1)
	  neighbor = @cells[y + 1][x + 1]
      count += 1 if neighbor.is_alive
	end

	if y < (@numRows - 1) and x > 0
	  neighbor = @cells[y + 1][x - 1]
      count += 1 if neighbor.is_alive
	end

	if y > 0 and x > 0
	  neighbor = @cells[y - 1][x - 1]
      count += 1 if neighbor.is_alive
	end

	if y > 0
	  neighbor = @cells[y - 1][x]
      count += 1 if neighbor.is_alive
	end

	if x < (@numCols - 1)
	  neighbor = @cells[y][x + 1]
      count += 1 if neighbor.is_alive
	end

	if y < (@numRows - 1)
	  neighbor = @cells[y + 1][x]
      count += 1 if neighbor.is_alive
    end

	if x > 0
	  neighbor = @cells[y][x - 1]
      count += 1 if neighbor.is_alive
	end

	count
  end
end

class Cell
  attr_accessor  :is_alive, :count_neighbours

  def initialize()
    @is_alive = [true, false].sample
  end
  
  def to_s
    @is_alive ? '*' : ' '
  end
end

Game.new(15, 15, 10).play!