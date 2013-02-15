#

require_relative 'matcher'

module Revo
  class Template
    def expand(hash, ellipsis_vars)
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
    def expand(hash, ellipsis_vars)
      result = []
      @data.each do |x|
        expansion = x.expand(hash, ellipsis_vars)
        if x.is_a? EllipsisTemplate
          result.concat(expansion)
        else
          result << expansion
        end
      end

      result, tail = result[0..-2], result[-1] if @improper
      result = Cons.construct(result)
      result.tail.cdr = tail if @improper
      result
    end
  end

  class ConstantTemplate
    attr_accessor :const
    def initialize(const)
      @const = const
    end

    def expand(*)
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
    def expand(hash, _)
      value = hash[@name]
      if value.is_a? EllipsisMatch
        raise 'Error to apply an ellipsis value on a direct variable'
      end
      value
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

    def expand(hash, ellipsis_vars)
      result = []
      nova_hash = hash.dup
      count = hash[ellipsis_vars[0]].length
      count.times do |i|
        ellipsis_vars.each do |var|
          nova_hash[var] = hash[var][i]
        end
        result << @template.expand(nova_hash, ellipsis_vars)
      end
      result
    end

    def inspect
      "#{@template.inspect}..."
    end
  end

end
