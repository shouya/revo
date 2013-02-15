#
#
#
#

require_relative 'syntax_rule'

module Revo
  class Macro
    attr_accessor :keywords, :name, :rules, :hygienic

    def initialize(name, keywords, hygienic = false)
      @name = name
      @keywords = keywords
      @rules = []
      @hygienic = hygienic
    end

    def define_rule(pattern, template)
      @rules << SyntaxRule.new(self, @keywords, pattern, template)
    end

    def call(scope, args)
      expansion = expand(scope, args)
      return Revo.eval(expansion, scope) if expansion
      raise 'Syntax error!'
    end

    def expand(scope, args)
      @rules.each do |rule|
        if match_result = rule.match(args)
          return rule.expand(match_result, scope)
        end
      end
      return nil
    end
  end
end
