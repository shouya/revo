#

module Revo
  class Template
    def expand(env)
    end
  end

  class SequenceTemplate
    attr_accessor :data, :improper

    def initialize
      @data = []
      @improper = false
    end
    def <<(ele)
      @data << ele
    end
    def inspect
      "[#{@improper ? 'improper-':''}seq: " \
        "#{@data.map(&:inspect).join(" ")}]"
    end
  end

  class ConstantTemplate
    attr_accessor :const
    def initialize(const)
      @const = const
    end

    def expand(_)
      @const
    end
    # for debugging use only
    def inspect
      "<const: #{@const.inspect}>"
    end
  end

  class SymbolTemplate
    attr_accessor :name
    def initialize(name)
      @name = name
    end
    def expand(env)
    end
    def inspect
      "<:#@name>"
    end
  end

  class EllipsisTemplate
    attr_accessor :template
    def initialize(template)
      @template = template
    end

    def inspect
      "#{@template.inspect}..."
    end
  end

end
