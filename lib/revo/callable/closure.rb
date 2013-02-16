#

module Revo
  class Closure
    attr_accessor :lexical_scope, :params, :body
    def initialize(lexical_scope, params, body)
      @lexical_scope = lexical_scope
      @params = params
      @body = body
    end

    def call(runtime_scope, args)
      scope = Scope.new(@lexical_scope)
      args = args.map {|arg| Revo.eval(arg, runtime_scope) }

      apply(scope, args)
    end

    def apply(scope, args)
      arg_idx = 0

      if @params.is_a? Cons
        param_tail = @params.each do |param|
          scope[param.to_s] = args[arg_idx]
          arg_idx += 1
        end
        if not param_tail.nil? and param_tail.cdr != NULL
          scope[param_tail.cdr.to_s] = Cons.construct(args[arg_idx..-1])
        end
      elsif @params.is_a? Symbol
        scope[@params.val] = Cons.construct(args)
      end

      Revo.eval(@body, scope)
    end

    def inspect
      "#<Closure:#{object_id} binding:##{@lexical_scope.object_id}" \
      " param:#{@params.inspect} body:#{@body.inspect}>"
    end
  end
end
