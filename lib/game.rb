require 'universe'
require 'seeder'

module Game
  extend self
  BOUNDS = [24, 48]

  def run(seed)
    iterations = 0
    while true
      last_seed = seed
      universe = universe_from(seed)
      universe.draw
      seed = universe.seed_generation
      iterations += 1
      reseed if should_break?(last_seed, seed)
      sleep 0.05
    end
  end

private

  def reseed
    Game.run(Seeder.generate_matrix)
  end

  def should_break?(last, this)
    last == this || this.empty?
  end

  def universe_from(seed)
    Universe.new(seed, BOUNDS)
  end
end
