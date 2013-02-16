#

require_relative 'matcher'
require_relative '../data/dynamic_closure'


module Revo
  class Template
    def expand(hash, scope, transformer)
      raise 'Virtual method invoked!'
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
    def expand(hash, scope, transformer)
      result = []
      @data.each do |x|
        expansion = x.expand(hash, scope, transformer)
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
    def names
      @data.inject([]) {|xs,x| x.respond_to?(:names) ? xs |= x.names : xs}
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
    def expand(hash, scope, transformer)
      if hash.include? @name
        value = hash[@name]
        if value.is_a? EllipsisMatch
          raise "Error to apply an ellipsis value on a direct variable #{@name}"
        end
        value
      else
        la_nomo = Symbol.new(@name)
        if transformer.hygienic
          DynamicClosure.construct(transformer.lexical_scope, la_nomo)
        else
          la_nomo
        end
      end
    end
    def inspect
      "<:#@name>"
    end
    def names
      [@name]
    end
  end

  class EllipsisTemplate
    attr_accessor :template
    def initialize(template)
      @template = template
    end

    def expand(hash, scope, transformer)
      result = []
      ellipsis_vars = names & (transformer.variables|transformer.ellipsis_vars)

      count = ellipsis_vars.length == 0 ? 0 :
        ellipsis_vars.map {|x| hash[x]}.map(&:length).max
      count.times do |i|
        nova_hash = hash.dup
        ellipsis_vars.each do |var|
          nova_hash[var] = hash[var][i] || EllipsisMatch.new
        end
        result << @template.expand(nova_hash, scope, transformer)
      end
      result
    end

    def inspect
      "<#{@template.inspect}...>"
    end
    def names
      @template.names
    end
  end

end
