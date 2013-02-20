#

require_relative 'callable/primitive_procedure'
require_relative 'callable/primitive_macro'
require_relative 'callable/closure'
require_relative 'callable/macro'

module Revo
  class Scope
    extend Forwardable
    attr_accessor :symbols, :parent, :runtime

    def_delegators :@symbols, :'[]='

    def initialize(parent)
      @parent = parent
      @symbols = {}
      @runtime = parent.runtime if parent
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

    def defined?(name)
      !!find_scope(name)
    end
    def define(name, &block)
      self[name.to_s] = PrimitiveProcedure.new(name, &block)
    end
    def syntax(name, &block)
      self[name.to_s] = PrimitiveMacro.new(name, &block)
    end
    def define_alias(new_name, reference)
      raise "#{reference.to_s} doesn't exist!" unless
        find_scope(reference.to_s)
      self[new_name.to_s] = self[reference.to_s]
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
    alias_method :exec, :eval

  end
end
