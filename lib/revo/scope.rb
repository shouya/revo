#

require_relative 'callable/function'

module Revo
  class Scope
    extent Forwardable
    attr_accessor :symbols, :parent

    def_delegators :@symbols, :'[]='

    def initialize(parent)
      @parent = parent
    end

    def [](name)
      @find_scope
    end

    def find_scope(name)
      return self if @symbols.has_key? name
      return @parent.find_scope(name) if @parent
      nil
    end

    def define(name, &block)
      self[name] = Function.new(&block)
    end

    def set!

    end

  end
end
