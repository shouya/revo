#

require_relative 'currying'

module Revo
  class Curry
    include Currying

    def initialize(proc, args, new_arity = nil)
      @arity = new_arity || (proc.arity - args.length)
      @args = args
      @proc = proc
    end

    def call(env, args)
      if curry?(args)
        curry(args)
      else
        args = @args + args.to_a
        @proc.call(env, Cons.construct(args))
      end
    end

  end
end
