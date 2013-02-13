#


module Revo
  class Matcher
    def initialize
    end

    def match(expr, hash)
      raise 'Abstract method invoked!'
    end
  end

  class SequenceMatcher < Matcher
    attr_accessor :matchers, :improper

    def initialize
      super
      @matchers = []
      @improper = false
    end

    def <<(matcher)
      matchers << matcher
    end
    def pop
      matchers.pop
    end

    def match(expr, hash)
      return nil unless expr.is_a? Cons

      elements = []
      tail = expr.each do |x|
        elements << x
      end

      ele_ptr = 0
      mtc_ptr = 0

      loop do

      end
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

  class WhateverExprMatch < Matcher
    def match(expr, hash)
      hash
    end
  end

  class ElipsisMatch < Matcher
    attr_accessor :value
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
  class RestMatcher < Matcher
  end
end
