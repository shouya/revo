#
#
#
#

module Revo
  class Syntax
    attr_accessor :keywords, :name, :rules

    def initialize(keywords)
      @keywords = keywords
      @names = names
      @rules = []
    end

    def define_rule(pattern, template)e
      @rules << SyntaxRule.new(@keywords, pattern, template)
    end

  end
end
