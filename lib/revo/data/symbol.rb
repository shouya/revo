#

module Revo
  class Symbol
    include Expression
    include Value

    def initialize(val)
      super(val.to_s)
    end

    def eval(scope)
      scope[@val]
    end

    def to_s
      @val
    end
    alias_method :inspect, :to_s

  end
end
