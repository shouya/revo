#

require_relative 'primitive_helpers'
require_relative 'currying'

module Revo
  class PrimitiveProcedure
    include Currying

    attr_accessor :scope, :name, :body
    def initialize(name = nil, &block)
      @name = name
      @body = block
      @arity = block.arity
    end

    def call(scope, args)
      args = args.map { |arg| Revo.eval(arg, scope) }
      if curry? args
        return curry args
      end
      retval = apply(scope, args)
      retval
    end

    def apply(scope, args)
      mybody = @body
      Object.new.instance_eval do
        singleton_class.class_eval do
          include PrimitiveHelpers
          attr_accessor :env
        end
        @env = scope
        instance_exec(*args, &mybody)
      end
    end
  end
end
