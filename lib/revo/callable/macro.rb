#
#
#
#

require_relative 'syntax_rule'

module Revo
  class Macro
    attr_accessor :keywords, :name, :rules

    def initialize(name, keywords)
      @name = name
      @keywords = keywords
      @rules = []
    end

    def define_rule(pattern, template)
      @rules << SyntaxRule.new(@keywords, pattern, template)
    end

    def call(scope, args)
      @rules.each do |rule|
        if match_result = rule.match(args, scope)
          return Revo.eval(rule.expand(match_result), scope)
        end
      end
      raise 'Syntax error!'
    end
  end
end
