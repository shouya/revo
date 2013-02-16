# -*- coding: utf-8 -*-
#

$: << File.expand_path('../revo', __FILE__)

require 'forwardable'

require_relative 'revo/data/expression'
require_relative 'revo/data/value'
require_relative 'revo/data/cons'
require_relative 'revo/data/symbol'
require_relative 'revo/data/character'
require_relative 'revo/data/vector'
require_relative 'revo/runtime'
require_relative 'revo/parser.tab'

module Revo
  class << self
    PRIMITIVE_RUBY_TYPES = [String, TrueClass, FalseClass,
                            Integer, Rational, Float, Complex].freeze

    def parse(code)
      Parser.parse(code)
    end

    def eval(expr, scope)
      return expr if PRIMITIVE_RUBY_TYPES.any? {|type| expr.is_a? type }
      return expr.eval(scope) if expr.is_a? Expression
      return expr.val if expr.is_a? Value
      raise 'expression type is unable to be evaluated'
    end

    REVO_TYPES = (PRIMITIVE_RUBY_TYPES + [Cons, Closure, DynamicClosure]).freeze

    def convert(val)
      return val if REVO_TYPES.any? {|type| val.is_a? type }
      return Revo::Symbol.new(val.to_s) if val.is_a? ::Symbol
      return Cons.construct(val) if val.is_a? Array
      return val
    end

    def is_true?(val)
      return !!val if PRIMITIVE_RUBY_TYPES.any? {|type| val.is_a? type}
      return false if val == NULL
      return true
    end
    def is_false?(val)
      !is_true?(val)
    end

    # This method is from Heist project:
    #+https://github.com/jcoglan/heist/blob/master/lib/heist.rb
    #
    # Returns the result of dividing the first argument by the second. If both
    # arguments are integers, returns a rational rather than performing integer
    # division as Ruby would normally do.
    def divide(op1, op2)
      [op1, op2].all? { |value| Integer === value } ?  \
        Rational(op1, op2) : op1.to_f / op2
    end
  end

  NULL = Cons.new(nil, nil)
  NULL.freeze
end
