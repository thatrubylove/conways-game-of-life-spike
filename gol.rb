require 'curses'

class Universe
  attr_reader :cells

  def initialize(cells=[], size=[10,10])
    @cells = cells
    @rows, @columns = *size
  end

  def living_cell?(x,y)
    @cells.include?([x,y])
  end

  def dead_cell?(x,y)
    !living_cell?(x,y)
  end

  def neighborhood(position, cell_position)
    pos_x, pos_y = *position
    cpos_x, cpos_y = *cell_position
    [(pos_x - cpos_x).abs, (pos_y - cpos_y).abs]
  end

  def neighbors_to(x,y)
    @cells.select do |cell_x, cell_y|
      position = [x,y]
      cell_position = [cell_x, cell_y]
      lives_near?(neighborhood(position, cell_position))
    end
  end

  def lives_near?(position)
    x, y = *position
    x <= 1 && y <= 1 && !(x == 0 && y == 0)
  end

  def seed_generation
    rows, columns = [(0...@rows).to_a, (0...@columns).to_a]
    rows.product(columns).select {|x, y| is_viable?(x,y) }
  end

  def neighbor_count_near(x,y)
    neighbors_to(x,y).count
  end

  def has_2_or_3_neighbors?(x,y)
    has_2_neighbors?(x,y) || has_3_neighbors?(x,y)
  end

  def has_2_neighbors?(x,y)
    neighbor_count_near(x,y) == 2
  end

  def has_3_neighbors?(x,y)
    neighbor_count_near(x,y) == 3
  end

  def should_survive?(x,y)
    living_cell?(x,y) && has_2_or_3_neighbors?(x,y)
  end

  def should_ressurect?(x,y)
    dead_cell?(x,y) && has_3_neighbors?(x,y)
  end

  def is_viable?(x,y)
    should_survive?(x,y) || should_ressurect?(x,y)
  end

  def draw
    Curses.setpos(0, 0)
    Curses.addstr(0.upto(@rows - 1).map {|x| cells_on(x) }.join("\n"))
    Curses.refresh
  end

  def cells_on(x)
    0.upto(@columns - 1).map {|y| draw_cell(x, y) }.join
  end

  def draw_cell(x, y)
    living_cell?(x, y) ? "+" : "."
  end

end

module Game
  extend self
  BOUNDS = [24, 48]

  def run(seed)
    while true
      last_seed = seed
      universe = universe_from(seed)
      universe.draw
      seed = universe.seed_generation
      exit if should_break?(last_seed, seed)
    end
  end

private

  def should_break?(last, this)
    last == this || this.empty?
  end

  def universe_from(seed)
    Universe.new(seed, BOUNDS)
  end
end

INITIAL_SEED = [
  [5,7], [5,9], [5,2], [5,3], [5,6],
  [1,7], [1,9], [1,2], [1,3], [1,6],
  [2,7], [2,9], [2,2], [2,3], [2,6],
  [3,7], [3,9], [3,2], [3,3], [3,6],
  [4,7], [4,9], [4,2], [4,3], [4,6],
  [5,7], [5,9], [5,2], [5,3], [5,6],
  [6,7], [6,9], [6,2], [6,3], [6,6]
]

Game.run(INITIAL_SEED)
puts "Simulation took #{iterations} generations to go stagnant"
