#

require_relative 'expression'

module Revo
  class Promise
    include Expression
    include Value

    attr_accessor :binding

    def initialize(val, bd)
      @val = val
      @binding = bd
    end

    def eval(*)
      self
    end
    def force(*)
      Revo.eval(@val, @binding)
    end
  end
end
