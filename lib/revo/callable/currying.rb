#


module Revo
  module Currying
    attr_accessor :arity

    def calculate_arity(params)
      return -1 unless params.is_a? Cons
      prm = []
      tail = params.each {|x| prm << x }

      return prm.length if tail.cdr == NULL
      return -(prm.length + 1)
    end

    def arity_compatible?(given)
      if @arity >= 0 && given == @arity or
          @arity < 0 && given >= -(@arity + 1)
        return true
      end
      false
    end

    def format_arity_string
      case
      when @arity == 0 then '0'
      when @arity < 0 then "#{-(@arity + 1)}+"
      when @arity > 0 then @arity.to_s
      end
    end

    def report_arity_mismatch(given, accepted)
      msg = "wrong number of arguments (#{given} for " <<
        "#{format_arity_string(accepted)})"
      raise msg
    end

    def curry(args)
      require_relative 'curry'

      raise 'Invalid currying' unless self.is_a? Currying
      Revo::Curry.new(self, args)
    end

    def curry?(args)
      @arity >= 0 and args.length < @arity
    end

    def force_curry(arity)
      raise 'Invalid arity' if arity <= 0
      raise 'Invalid arity' unless arity_compatible?(arity)
      Revo::Curry.new(self, [], arity)
    end
  end
end
