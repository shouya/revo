# -*- coding: utf-8 -*-
#

$: << File.expand_path('../revo', __FILE__)

require 'forwardable'

%w[scanner parser.tab
   callable/primitive_procedure callable/primitive_macro callable/closure
   scope runtime value expression
   data/cons data/character data/symbol data/vector].map do |x|
  require x
end

module Revo
  class << self
    PRIMITIVE_RUBY_TYPES = [String, TrueClass, FalseClass,
                            Integer, Float, Complex].freeze

    def eval(expr, scope)
      return expr if PRIMITIVE_RUBY_TYPES.any? {|type| expr.is_a? type }
      return expr.eval(scope) if expr.is_a? Expression
      return expr.val if expr.is_a? Value
      return expr
    end

    REVO_TYPES = (PRIMITIVE_RUBY_TYPES + [Cons, Closure]).freeze

    def convert(val)
      return val if REVO_TYPES.any? {|type| val.is_a? type }
      return Revo::Symbol.new(val.to_s) if val.is_a? ::Symbol
      return Cons.construct(val) if val.is_a? Array
      return val
    end
  end

  NULL = Cons.new(nil, nil)
  NULL.freeze
end
