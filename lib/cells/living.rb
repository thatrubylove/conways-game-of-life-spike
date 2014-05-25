module Cells::Living
  extend self
  def to_s
    "∆"
  end
  alias_method :inspect, :to_s
end
