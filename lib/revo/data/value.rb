#

module Revo
  module Value
    attr_accessor :val

    def initialize(val)
      @val = val
    end

    def ==(another)
      return false unless another.is_a? Value
      @val == another.val
    end
  end
end
