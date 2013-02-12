# -*- racc -*-
#
# command to compile release:
#   $ racc -oparser.tab.rb -vg grammar.y
# command to compile debug:
#   $ racc -oparser.tab.rb grammar.y
#



class Revo::Parser
options no_result_var
start main
rule

         main: multi_expr        { val[0] }
             | expr              { val[0] }
             | /* empty */       { NULL }

   multi_expr: multi_expr_x      {
                 SExpr.new(Revo::Symbol.new('begin'))
                      .cons!(val[0])
               }

 multi_expr_x: expr expr         { SExpr.new(val[0]).cons!(SExpr.new(val[1])) }
             | expr multi_expr_x { SExpr.new(val[0]).cons!(val[1]) }



      literal: STRING   { String.new(val[0]) }
             | INTEGER  { Number.new(val[0]) }
             | FLOAT    { Number.new(val[0]) }
             | SYMBOL   { Symbol.new(val[0]) }
             | BOOLEAN  { Bool.new(val[0]) }

         expr: literal  { val[0] }
             | list     { val[0] }
             | pair     { val[0] }
             | quoted_expr      { val[0] }
             | quasiquote       { val[0] }
             | unquote          { val[0] }
             | unquote_splicing { val[0] }

         pair: LBRACKET pair_content RBRACKET { val[1] }

 pair_content: expr PERIOD expr {
                 SExpr.new(val[0]).cons!(val[2])
               }
             | expr pair_content      {
                 SExpr.new(val[0]).cons!(val[1])
               }

         list: LBRACKET list_content RBRACKET  { val[1] }


 list_content: /* empty */       { NULL }
             | expr list_content { SExpr.new(val[0]).cons!(val[1]) }

  quoted_expr: QUOTE expr        {
                 SExpr.new(Symbol.new('quote')).cons!(SExpr.new(val[1]))
               }

   quasiquote: BACKQUOTE expr    {
                 SExpr.new(Symbol.new('quasiquote')).cons!(SExpr.new(val[1]))
               }
      unquote: COMMA expr        {
                 SExpr.new(Symbol.new('unquote')).cons!(SExpr.new(val[1]))
               }
unquote_splicing: COMMA_AT expr  {
                 SExpr.new(Symbol.new('unquote-splicing'))
                      .cons!(SExpr.new(val[1]))
               }



---- header
require_relative 'prim_types'
require_relative 'symbol'
require_relative 'sexpr'
require_relative 'scanner'

class Revo::ParseError < Racc::ParseError
  attr_accessor :context, :message
  def initialize(msg, ctx)
    @message = msg
    @context = ctx
  end
end

---- inner
attr :scanner
def initialize(scanner)
  @scanner = scanner
end

def next_token
  @scanner.next_token
end


def on_error(t, sym, stack)
  context =  print_context(@scanner.line_no, @scanner.column_no, 3)
  msg = "Syntax error at "
  msg << "#{@scanner.filename}:#{@scanner.line_no}:#{@scanner.column_no}. "
  msg << "Unexpected token '#{sym}'."
  raise Revo::ParseError.new(msg, context)
end

def self.parse(str)
  new(Scanner.new.tap{|x| x.scan_string(str) }).do_parse
end

private
def print_context(line_no, column_no, context)
  retval = ''
  source = @scanner.source
  source_lines = source.lines.count

  range_beg = line_no - context < 0 ? 0 : line_no - context
  range_end = line_no + context >= source_lines ? source_lines - 1 \
              : line_no + context

  line_no = range_beg if line_no < range_beg
  line_no = range_end if line_no > range_end

  range_beg.upto(line_no) do |l|
    retval << "#{l.to_s.rjust(3)}: #{source.lines.to_a[l-1].chomp}\n"
  end

  retval << "#{'-' * 3}--#{'-' * column_no}^\n"

  (line_no + 1).upto(range_end) do |l|
    retval << "#{l.to_s.rjust(3)}: #{source.lines.to_a[l-1].chomp}\n"
  end
  retval
end

