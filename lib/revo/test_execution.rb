#

require_relative '../revo'
require_relative 'callable/syntax_rule'


require 'ap'

include Revo

rt = Runtime.new
# rt.eval(Parser.parse(DATA.read))
syntax = SyntaxRule.new([],
                        Parser.parse('(a b c)'),
                        Parser.parse(DATA.read))
ap syntax.template

# ap syntax.pattern.match(Parser.parse('(1 2 (3 4 5 6) (7 8 9))'), {})


__END__
(a b (c d ... e . f) ...)
; (a b (c d ...) ...)
