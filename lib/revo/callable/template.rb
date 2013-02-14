#

module Revo
  class Template
    def expand(env)
    end
  end

  class ConstantTemplate
    attr_accessor :const
    def initialize(const)
      @const
    end

    def expand(_)
      @const
    end
  end

  class ConsTemplate
  end

  class SymbolTemplate
    attr_accessor :name
    def initialize(name)
      @name = name
    end
    def expand(env)
    end
  end

end
