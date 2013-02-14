#

module Revo
  class Closure
    attr_accessor :lexical_scope, :params, :body
    def initialize(lexical_scope, params, body)
      @lexical_scope = lexical_scope
      @params = params
      @body = body
    end

    def call(env, args)
      scope = Scope.new(@lexical_scope)
      args = args.map {|arg| Revo.eval(arg, env) }
      arg_idx = 0

      param_tail = @params.each do |param|
        scope[param.to_s] = args[arg_idx]
        arg_idx += 1
      end

      if not param_tail.nil? and param_tail.cdr != NULL
        scope[param_tail.cdr.to_s] = Cons.construct(args[arg_idx..-1])
      end

      Revo.eval(@body, scope)
    end
  end
end
