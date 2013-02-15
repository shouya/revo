#

module Revo
  class Cons
    include Enumerable
    include Expression

    attr_accessor :car, :cdr

    def initialize(car, cdr)
      @car = Revo.convert(car)
      @cdr = Revo.convert(cdr)
    end

    def each
      return if null?
      iter, _tail = self, NULL
      while iter.is_a?(Cons) and not iter.null?
        yield iter.car if block_given?
        _tail = iter
        iter = iter.cdr
      end
      _tail
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
      return '()' if self == NULL
      items = []
      tail = each { |x| items << x.inspect }
      unless tail.cdr == NULL
        items << '.' << tail.cdr.inspect
      end
      "(#{items.join(' ')})"
    end

    def eval(scope)
      return NULL if null?
      first = Revo.eval(@car, scope)
      first.call(scope, @cdr)
    end

    def length
      count
    end

    class << self
      def [](car, cdr)
        new(car, cdr)
      end

      def construct(enum)
        curr = NULL

        enum.reverse_each do |val|
          val = yield(val) if block_given?
          curr = new(val, curr)
        end

        curr
      end
    end
  end

end
