#

require_relative '../data/dynamic_closure'

module Revo
  class EllipsisMatch
    extend Forwardable

    attr_accessor :data
    def initialize
      @data = []
    end

    def_delegators(:@data, :<<, :[], :length, :to_s, :inspect)
  end

  class Matcher
    def match(expr, hash)
      raise 'Abstract method invoked!'
    end
  end

  class SequenceMatcher < Matcher
    attr_accessor :matchers, :improper, :obligate

    def initialize
      @matchers = []
      @improper = false
      @obligate = nil
    end

    def <<(matcher)
      matchers << matcher
    end
    def pop
      @matchers.pop
    end

    def match(expr, hash)
      return nil unless expr.is_a? Cons
      return nil if expr.tail.improper_pair? and not @improper

      mtc_ptr = 0
      while mtc_ptr < @matchers.length
        matcher = @matchers[mtc_ptr]
        if matcher.is_a? EllipsisMatcher
          hash = matcher.match(expr, hash, @obligate)
          (expr.length - @obligate).times { expr = expr.cdr }
        elsif matcher.is_a? RestMatcher
          hash = matcher.match(expr, hash)
          expr = NULL
          break
        else
          hash = matcher.match(expr.car, hash)
          expr = expr.cdr
        end

        mtc_ptr += 1
        return nil if hash.nil?
      end

      return nil if expr.is_a? Cons and expr != NULL
      hash
    end

    def inspect
      "<seq#{@improper ? '-improper' : ''}" \
      "(#{@obligate}) " \
      "#{@matchers.map(&:inspect).join(' ')}>"
    end
  end

  class ConstantMatcher < Matcher
    attr_accessor :const
    def initialize(const)
      @const = const
    end

    def match(expr, hash)
      expr == @const ? hash : nil
    end

    def inspect
      "<const: #{@const}>"
    end
  end

  class KeywordMatcher < Matcher
    attr_accessor :keyword
    def initialize(keyword)
      @keyword = keyword
    end

    def match(expr, hash)
      (expr.is_a? Symbol) && (expr.val == @keyword) ? hash : nil
    end

    def inspect
      "<keyword: #{keyword}>"
    end
  end

  class WhateverExprMatcher < Matcher
    def match(expr, hash)
      hash
    end
    def inspect
      "<whatever-you-like>"
    end
  end

  class EllipsisMatcher < Matcher
    attr_accessor :matcher
    def initialize(matcher)
      @matcher = matcher
    end

    def match(expr, hash, obligate)
      result = Hash.new
      tmp = {}
      # eat up all rest expressions but those obligated
      return nil if obligate > expr.length
      sacrifice = expr.to_a[0..-(obligate + 1)]
      sacrifice.each do |x|
        tmp = @matcher.match(x, tmp)
        return nil if tmp.nil?
        tmp.each do |key, value|
          result[key] ||= EllipsisMatch.new
          result[key] << value
        end
      end

      if tmp.keys.length >= 1
        return hash.merge(result)
      end
      hash
    end
    def inspect
      "<#{@matcher.inspect} ...>"
    end
  end
  class NameMatcher < Matcher
    attr_accessor :name
    def initialize(name)
      @name = name
    end
    def match(expr, hash)
      hash.merge(@name => expr)
#                 expr : DynamicClosure.construct(scope, expr))
    end

    def inspect
      "<symbol: #{@name}>"
    end
  end
  class RestMatcher < NameMatcher; end

end
