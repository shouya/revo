#

module Revo
  class PrimitiveMacro
    attr_accessor :scope, :name, :body
    def initialize(name = nil, &block)
      @name = name
      @body = block
    end

    def call(scope, args)
      apply(scope, args.to_a)
    end

    def apply(scope, args)
      mybody = @body
      Object.new.instance_eval do
        singleton_class.class_eval { attr_accessor :env }
        @env = scope
        instance_exec(*args, &mybody)
      end
    end
  end
end
