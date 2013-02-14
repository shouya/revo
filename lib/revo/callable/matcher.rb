#


module Revo
  class EllipsisMatch
    attr_accessor :data
    def initialize
      @data = []
    end
    def <<(value)
      @data << value
    end

    def to_s
      @data.to_s
    end
    alias_method :inspect, :to_s
  end
  class NormalMatch
    attr_accessor :val
  end

  class Matcher
    def match(expr, hash)
      raise 'Abstract method invoked!'
    end
  end

  class SequenceMatcher < Matcher
    attr_accessor :matchers, :improper

    def initialize
      @matchers = []
      @improper = false
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
          hash = matcher.match(expr, hash)
          expr = expr.tail
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

      return nil if expr.cdr != NULL
      hash
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
  end

  class KeywordMatcher < Matcher
    attr_accessor :keyword
    def initialize(keyword)
      @keyword = keyword
    end

    def match(expr, hash)
      (expr.is_a? Symbol) && (expr.val == @keyword) ? hash : nil
    end
  end

  class WhateverExprMatcher < Matcher
    def match(expr, hash)
      hash
    end
  end

  class EllipsisMatcher < Matcher
    attr_accessor :matcher
    def initialize(matcher)
      @matcher = matcher
    end

    def match(expr, hash)
      result = Hash.new
      tmp = {}
      # eat up all rest expressions
      expr.each do |x|
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
  end
  class NameMatcher < Matcher
    attr_accessor :name
    def initialize(name)
      @name = name
    end
    def match(expr, hash)
      hash.merge({@name => expr})
    end
  end
  class RestMatcher < NameMatcher; end

end
