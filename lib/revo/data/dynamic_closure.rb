#

require_relative 'expression'

module Revo
  class DynamicClosure
    include Expression

    attr_accessor :dynamic_scope, :expression

    def initialize(dynamic_scope, expression)
      @dynamic_scope = dynamic_scope
      @expression = expression
    end

    def eval(_)
      Revo.eval(@expression, @dynamic_scope)
    end
  end
end
