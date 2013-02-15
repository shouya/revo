#

module Revo
  module PrimitiveHelpers
    def call(name, *args)
      env[name.to_s].call(env, Cons.construct(args))
    end

    def cons(car, cdr)
      Cons.new(car, cdr)
    end

    def autobegin(*body)
      if body.length == 0
        NULL
      elsif body.length == 1
        body[0]
      else
        cons(:begin, Cons.construct(body))
      end
    end

    def list(*vals)
      Cons.construct(vals)
    end
    def assert(expr, msg = nil)
      return if expr
      raise(*(msg ? [msg] : []))
    end

    def quote(obj)
      Cons.construct([:quote, obj])
    end
  end
end
