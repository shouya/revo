# -*- coding: utf-8 -*-
#

$: << File.expand_path('../revo', __FILE__)

require 'forwardable'

require_relative 'revo/runtime'
require_relative 'revo/data/expression'
require_relative 'revo/data/value'
require_relative 'revo/data/cons'
require_relative 'revo/data/symbol'
require_relative 'revo/callable/closure'
require_relative 'revo/callable/dynamic_closure'

module Revo
  class << self
    PRIMITIVE_RUBY_TYPES = [String, TrueClass, FalseClass,
                            Integer, Float, Complex].freeze

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
  end

  NULL = Cons.new(nil, nil)
  NULL.freeze
end
