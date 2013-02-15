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
      puts args.inspect
      puts '-------'
      Revo.eval(expand(scope, args).tap{|x| p x}, scope)
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
