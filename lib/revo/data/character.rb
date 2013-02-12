#


module Revo
  class Character
    include Comparable

    attr_accessor :char

    def initialize(char)
      @char = char
    end

    def char_code
      @char.each_byte.to_a.last
    end


    def ==(rhs)
      @char == rhs.char
    end

    def <=>(other)
      char_code <=> other.char_code
    end

    def upcase
      self.class.new(@char.upcase)
    end
    def downcase
      self.class.new(@char.downcase)
    end

    def to_s
      @char
    end
    def inspect
      "#\\#{@char}"
    end
  end
end
