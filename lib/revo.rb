# -*- coding: utf-8 -*-
#

$: << File.expand_path('../revo', __FILE__)

require 'forwardable'

%w[scanner parser.tab scope runtime value expression
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
      return expr
    end
  end
end
