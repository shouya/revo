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
        prev = nil
        tail = pattern.each do |ele|
          if ele.is_a? Sybmol and ele.val == '...'
            seq.pop
            seq << ElipsisMatcher.new(prev.name)
          else
            prev = compile_pattern(ele)
          end
          seq_mt << prev
        end
        if tail.improper_pair?
          seq_mt << RestMatcher.new(tail.cdr)
          seq_mt.improper = true
        end
        seq_mt

      elsif pattern.is_a? Symbol
        name = pattern.val
        return KeywordMatcher.new(name) if @keywords.include? name
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
    end
  end
end
