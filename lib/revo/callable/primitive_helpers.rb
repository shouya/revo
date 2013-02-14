#

module Revo
  module PrimitiveHelpers
    def call(name, *args)
      env[name.to_s].call(env, Cons.construct(args))
    end
  end
end
