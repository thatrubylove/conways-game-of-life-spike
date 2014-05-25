module Seeder
  extend self
  def generate_matrix
    rand(40..200).times.map { [rand(24), rand(48)] }
  end
end
