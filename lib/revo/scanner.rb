#

require 'strscan'

module Revo
  class ScannerError < RuntimeError; end

  class LexicalError < ScannerError
    attr_reader :line_no, :column_no, :filename
    def initialize(ln_no, col_no, filename)
      @line_no = ln_no
      @column_no = col_no
      @filename = filename
    end
    def to_s
      "Lexical error at file #@filename:#@line_no:#@column_no."
    end
  end


  class Scanner
    include Enumerable

    class << self
      attr_reader :rules

      def rule(match, state = nil, &block)
        @rules ||= []
        @rules << [match, state, block]
      end
      def keyword_rule(keyword, state = nil, &block)
        rule(Regexp.new("\\b#{keyword.to_s}\\b"), state, &block)
      end
      def symbol_rule(symbol, state = nil, &block)
        rule(Regexp.new(Regexp.escape(symbol)), state, &block)
      end
    end

    attr_accessor :scanner
    attr_accessor :state
    attr_accessor :line_no, :column_no, :filename
    attr :match, :buffer

    def initialize
      @line_no = 1
      @column_no = 0
      @filename = '<unknown>'
      @buffer = {}
    end

    def each
      tokens = []
      while (token = next_token) != [false, false]
        tokens << token
      end
      tokens << [false, false]

      if block_given?
        return tokens.each { |x| yield x }
      else
        return tokens.each
      end
    end

    def scan_string(string)
      @scanner = ::StringScanner.new(string)
      @filename = '<string>'
    end
    def scan_file(filename)
      scan_string(File.read(filename))
      @filename = filename
    end
    def scan_stream(stream)
      scan_string(stream.read)
      @filename = '<stream>'
    end
    def scan_stdin
      scan_string($stdin.read)
      @filename = '<stdin>'
    end

    def find_match_rule
      state_filtered.detect {|x| @scanner.match? x[0] }
    end

    def next_token
      return [false, false] if @scanner.eos?

      result = nil
      loop do
        return [false, false] if @scanner.eos?
        matched_rule = match_rule
        raise LexicalError.new(@line_no, column_no,
                               @filename) if matched_rule.nil?
        scan_pattern(matched_rule[0])
        result = self.instance_eval(&matched_rule[2])
        break if result != :PASS
      end
      return result
    end

    def column_no
      @scanner.pos - @column_no
    end
    def source
      @scanner.string.dup
    end

    private
    def match_rule
      self.class.rules.select {|x| x[1] == @state }.detect do |x|
        @scanner.match? x[0]
      end
    end

    def scan_pattern(pat)
      @scanner.scan(pat)
      @match = @scanner.matched
    end

    def parse_int(str)
      str.to_i
    end
    def increase_line_number
      @column_no = @scanner.pos
      @line_no += 1
    end

    def string_unescape(str)
      str = str[1..-1]
      case str
      when 'n' then "\n"
      when 't' then "\t"
      when 'r' then "\r"
      when "\\" then "\\"
      else "\\#{str}"
      end
    end

    def string_octalnumber(str)
      str.to_i(8).chr
    end

    def string_hexnumber(str)
      str.to_i(16).chr
    end
  end
end

require_relative 'scanner_rules'


if __FILE__ == $0
  scanner = Revo::Scanner.new
  scanner.scan_string(' "ab"c ')
  puts scanner.each.to_a.inspect
end
