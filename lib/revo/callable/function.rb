#

module Revo
  class Function
    attr_accessor :scope, :name, :body
    def initialize(name = nil, &block)
      @name = name
      @body = block
    end

    def call(scope, args)
      args = args.map { |arg| Revo.eval(arg, scope) }
      apply(args)
    end

    def apply(args)
      @body.call(*args)
    end
  end
end
