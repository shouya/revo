#

module Revo
  class Template
    def expand
    end
  end

  class ConstantTemplate
    attr_accessor :const
    def initialize(const)
      @const
    end

    def expand
      @const
    end
  end

  class SymbolTemplate

  end

end
