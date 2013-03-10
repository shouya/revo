#

require_relative 'currying'

module Revo
  class Closure
    LAMBDA_UNICODE = "\xce\xbb".force_encoding('utf-8')
    include Currying

    attr_accessor :lexical_scope, :params, :body
    def initialize(lexical_scope, params, body)
      @lexical_scope = lexical_scope
      @params = params
      @body = body
      @arity = calculate_arity(params)
    end

    def call(runtime_scope, args)
      args = args.map {|arg| Revo.eval(arg, runtime_scope) }
      return curry(args) if curry?(args)

      scope = Scope.new(@lexical_scope)
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

    def to_s
      param_str = @params.is_a?(Symbol) ? @params.to_s :
        @params.map(&:to_s).join(' ')
      body_str = @body.to_s
      "#{LAMBDA_UNICODE}#{param_str}.#{body_str}"
    end
  end
end
