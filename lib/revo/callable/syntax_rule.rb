#
#
# Acknowledge https://github.com/pluskid/skime/
#


module Revo
  class SyntaxRule
    attr_accessor :keywords, :pattern, :template

    def initialize(keywords, pattern, template)
      @keywords = keywords
      @pattern = pattern
      @template = template
    end

    def compile_pattern(pattern)
      if pattern.is_a? Cons
        seq_mt = SequenceMatcher.new
        tail = pattern.each do |ele|
          if ele.is_a? Sybmol and ele.val == '...'
            prev = seq.pop
            raise 'Invalid "(...)" in syntax rule pattern.' if prev.nil?
            seq_mt << EllipsisMatcher.new(prev)
          else
            seq_mt << compile_pattern(ele)
          end
        end
        if tail.improper_pair?
          seq_mt << RestMatcher.new(tail.cdr)
          seq_mt.improper = true
        end
        seq_mt

      elsif pattern.is_a? Symbol
        name = pattern.val
        # (syntax-rules () (((foo ...) xxx)))
        return EllipsisMatcher.new(WhateverExprMatcher.new) if name == '...'

        # (syntax-rules (in) (((for x *in* list expr ...) xxx)))
        return KeywordMatcher.new(name) if @keywords.include? name

        # (syntax-rules () (((foo _ _) xxx)))
        return WhateverExprMatcher.new if name == ('_')     # \('_')/
        if @names.include? name
          raise 'Name "#{name}" is already existing.'
        end
        NameMatcher.new(name)

      else
        ConstantMatcher.new(pat)
      end
    end

    def compile_template(template)
      if template.is_a? Cons
      end
    end
  end
end
