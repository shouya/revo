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

    def inspect
      "#<DynamicClosure:#{object_id} #{@expression}>"
    end

    class << self
      def construct(scope, expr)
        if expr.is_a? Symbol
          #          return new(scope, expr) if scope.defined? expr.val
          return expr
        elsif expr.is_a? Cons and not expr.null?
          return new(scope, expr)
        else
          expr
        end
      end
    end
  end
end
