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
      return curry(args.map {|x| Revo.eval(x, env) }) if curry?(args)
      apply(env, args.to_a.map {|x| Revo.eval(x, env) })
    end

    def apply(env, args)
      @proc.apply(env, @args + args)
    end

  end
end
