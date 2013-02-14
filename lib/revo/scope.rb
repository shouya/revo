#

require_relative 'callable/primitive_procedure'
require_relative 'callable/primitive_macro'

module Revo
  class Scope
    extend Forwardable
    attr_accessor :symbols, :parent

    def_delegators :@symbols, :'[]='

    def initialize(parent)
      @parent = parent
      @symbols = {}
    end

    def [](name)
      name = name.to_s
      find_scope(name).instance_eval do
        raise "Symbol #{name} isn't found" if nil?
        return @symbols[name]
      end
    end

    def find_scope(name)
      name = name.to_s
      return self if @symbols.has_key? name
      return @parent.find_scope(name) if @parent
      nil
    end

    def define(name, &block)
      self[name.to_s] = PrimitiveProcedure.new(name, &block)
    end
    def syntax(name, &block)
      self[name.to_s] = PrimitiveMacro.new(name, &block)
    end

    def set!(name, val)
      name = name.to_s
      find_scope(name).instance_eval do
        raise "Symbol #{name} isn't found" if nil?
        @symbols[name] = val
      end
    end

    def eval(expr)
      Revo.eval(expr, self)
    end

  end
end
