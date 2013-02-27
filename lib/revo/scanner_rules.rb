#

module Revo
  class Scanner
    symbol_chars = '[\w_\-\@\?\$\%\^\*\+\/\~\=\<\>\!\.]'

    rule(/[ \t]+/) { :PASS }
    rule(/\r\n|\r|\n/) { increase_line_number; :PASS }

    symbol_rule(';') { @state = :COMMENT; :PASS }
    rule(/\r\n|\r|\n/, :COMMENT) { increase_line_number; @state = nil; :PASS }
    rule(/./, :COMMENT) { :PASS }

    symbol_rule('(')  { [:LBRACKET, nil]  }
    symbol_rule(')')  { [:RBRACKET, nil]  }
    symbol_rule(',@') { [:COMMA_AT, nil]  }
    symbol_rule(',')  { [:COMMA, nil]     }
    symbol_rule("'")  { [:QUOTE, nil]     }
    symbol_rule('&')  { [:AMPERSAND, nil] }
    symbol_rule('`')  { [:BACKQUOTE, nil] }

    rule(Regexp.new('\.' + "#{symbol_chars}+")) { [:SYMBOL, @match] }

    symbol_rule('.')  { [:PERIOD, nil]    }


    rule(/\d+\.\d*/) { [:FLOAT, parse_float(@match)] }
    rule(/\d+/)      { [:INTEGER, parse_int(@match)] }
    rule(/\#[tT]/)   { [:BOOLEAN, true] }
    rule(/\#[fF]/)   { [:BOOLEAN, false] }

    symbol_rule('"')         { @state = :DSTR; @buffer[:str] = ''; :PASS }
    symbol_rule('\"', :DSTR) { @buffer[:str] << '"'; :PASS }
    symbol_rule('"',  :DSTR) { @state = nil; [:STRING, @buffer.delete(:str)] }
    rule(/\\[\\ntr]/, :DSTR) { @buffer[:str] << string_unescape(@match);:PASS }
    rule(/\\0\d+/, :DSTR)    {
      @buffer[:str] << string_octalnumber(@match); :PASS
    }
    rule(/\\0[xX]\h+/, :DSTR){
      @buffer[:str] << string_hexnumber(@match); :PASS
    }
    rule(/./, :DSTR)         { @buffer[:str] << @match; :PASS }

    rule(Regexp.new("#{symbol_chars}+")) { [:SYMBOL, @match] }

  end
end
