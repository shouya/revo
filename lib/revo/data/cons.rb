#

module Revo
  class Cons
    include Enumerable

    attr_accessor :car, :cdr

    def initialize(car, cdr)
      @car = car
      @cdr = cdr
    end

    def each
      iter, tail = self, NULL
      while iter.is_a?(Cons) and not iter.null?
        yield iter.car if block_given?
        tail = iter
        iter = iter.cdr
      end
      tail
    end
    alias_method :tail, :each

    # return whether the cons is a valid pair
    def pair?
      !null?
    end

    # return whether the cons's cdr is not null
    def improper_pair?
      @cdr != NULL
    end

    # return whether the cons is null
    def null?
      self == NULL
    end

    def ==(rhs)
      return false unless rhs.is_a? Cons
      @car == rhs.car and @cdr == rhs.cdr
    end

    def to_s
      items = []
      tail = each { |x| items << x.to_s }
      unless tail.cdr == NULL
        items << '.' << tail.cdr.to_s
      end
      "(#{items.join(' ')})"
    end

    class << self
      def [](car, cdr)
        new(car, cdr)
      end

      def construct(enum)
        root, curr = nil, NULL
        enum.each do |val|
          val = yield(val) if block_given?
          curr = new(val, curr)
          root ||= curr
        end
        root || NULL
      end
    end
  end

  NULL = Cons.new(nil, nil)
  NULL.freeze
end
