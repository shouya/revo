#
#
# Acknowledge https://github.com/pluskid/skime/
#

require_relative 'matcher'
require_relative 'template'

module Revo
  class SyntaxRule
    attr_accessor :keywords, :pattern, :template, :variables, :ellipsis_vars

    def initialize(keywords, pattern, template)
      @variables = []
      @ellipsis_vars = []

      @keywords = keywords
      @pattern = compile_pattern(pattern)
      @template = compile_template(template)
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
            seq_mt.obligate = 0
            seq_mt << EllipsisMatcher.new(compile_pattern(token, true))
            pattern = pattern.cdr.cdr
            next
          end

          seq_mt << compile_pattern(token, in_ellipsis)
          seq_mt.obligate += 1 if ellipsis_existed
          pattern = pattern.cdr
        end

        unless pattern.is_a? Cons
          seq_mt.improper = true
          matcher = compile_pattern(pattern, in_ellipsis)
          seq_mt << RestMatcher.new(matcher.name)
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

        if @variables.include? name and
            (not in_ellipsis and not @ellipsis_vars.include? name)
          raise "Name \"#{name}\" is already existing."
        end
        in_ellipsis ? @ellipsis_vars |= [name] : @variables << name
        NameMatcher.new(name)

      else
        ConstantMatcher.new(pattern)
      end
    end

    def compile_template(template)
      if template.is_a? Cons
        seq_mt = SequenceTemplate.new
        ellipsis_existed = false
        while template.is_a? Cons and not template.null?
          token = template.car

          if template.cdr.is_a? Cons and
              template.cdr.car.is_a? Symbol and template.cdr.car.val == '...'
            raise 'Misplaced ellipsis' if ellipsis_existed
            ellipsis_existed = true
            seq_mt << EllipsisTemplate.new(compile_template(token))
            template = template.cdr.cdr
            next
          end

          seq_mt << compile_template(token)
          template = template.cdr
        end

        unless template.is_a? Cons
          seq_mt.improper = true
          seq_mt << compile_template(template)
        end
        seq_mt

      elsif template.is_a? Symbol and (@variables.include? template.val or
                                       @ellipsis_vars.include? template.val)
        SymbolTemplate.new(template.val)

      else
        ConstantTemplate.new(template)
      end

    end

    def match(args, scope)
      @pattern.match(args, {}, scope)
    end

    def expand(match_result)
      @template.expand(match_result)
    end

  end
end
