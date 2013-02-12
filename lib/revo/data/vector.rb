#

module Revo
  class Vector < Array
    def to_s
      "#(#{map(&:to_s).join(' ')})"
    end
    alias_method :inspect, :to_s
  end
end
