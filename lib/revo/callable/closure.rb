#

module Revo
  class Closure
    attr_accessor :lexical_scope, :params, :body
    def initialize(lexical_scope, params, body)
      @lexical_scope = lexical_scope
      @params = params
      @body = body
    end

    def call(_, args)
      scope = Scope.new(@lexical_scope)
      args = args.map {|arg| arg.eval(scope) }
      arg_idx = 0

      param_tail = @params.each do |param|
        scope[param.to_s] = args[arg_idx]
        arg_idx += 1
      end

      if param_tail.cdr != NULL
        scope[param_tail.cdr.to_s] = Cons.construct(args[arg_idx..-1])
      end

      @body.eval(scope)
    end
  end
end
