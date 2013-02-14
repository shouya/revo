#
#
# Acknowledge https://github.com/pluskid/skime/
#

require_relative 'matcher'
require_relative '../data/symbol'

module Revo
  class SyntaxRule
    attr_accessor :keywords, :pattern, :template

    def initialize(keywords, pattern, template)
      @variables = []
      @ellipsis_vars = []
      @keywords = keywords
      @pattern = compile_pattern(pattern)
      @template = template
    end

    def compile_pattern(pattern, in_ellipsis = false)

      if pattern.is_a? Cons
        seq_mt = SequenceMatcher.new

        ellipsis_existed = false
        while pattern.is_a? Cons and not pattern.null?
          token = pattern.car

          if pattern.cdr.is_a? Cons and
              pattern.cdr.car.is_a? Symbol and pattern.cdr.car.val == '...'
            raise 'Misplaced ellipsis' if ellipsis_existed
            ellipsis_existed = true
            seq_mt << EllipsisMatcher.new(compile_pattern(token, true))
            pattern = pattern.cdr.cdr
            next
          end

          seq_mt << compile_pattern(token, in_ellipsis)
          pattern = pattern.cdr
        end

        unless pattern.is_a? Cons
          seq_mt << compile_pattern(pattern, in_ellipsis)
          seq_mt.improper = true
        end
        seq_mt

      elsif pattern.is_a? Revo::Symbol
        name = pattern.val
        # (syntax-rules () (((foo *...*) xxx)))
        return EllipsisMatcher.new(WhateverExprMatcher.new) if name == '...'

        # (syntax-rules (in) (((for x *in* list expr ...) xxx)))
        return KeywordMatcher.new(name) if @keywords.include? name

        # (syntax-rules () (((foo *_* _) xxx)))               \(*_*)/
        return WhateverExprMatcher.new if name == ('_')     # \('_')/
        if @variables.include? name and not @ellipsis_vars.include? name
          raise "Name \"#{name}\" is already existing."
        end
        @variables << name
        @ellipsis_vars << name if in_ellipsis
        NameMatcher.new(name)

      else
        ConstantMatcher.new(pattern)
      end
    end

    def compile_template(template)
      if template.is_a? Cons
        template.each do
        end
      end
    end

  end
end
