#

require_relative '../revo'
require_relative 'callable/syntax_rule'


require 'ap'

include Revo

rt = Runtime.new
# rt.eval(Parser.parse(DATA.read))
syntax = SyntaxRule.new([],
                        Parser.parse('(a ...)'),
                        Parser.parse(DATA.read))
ap syntax.template
ap syntax.template
  .expand(syntax.pattern
            .match(Parser.parse('(1 2 3)'), {}),
          syntax.ellipsis_vars)

# ap syntax.pattern.match(Parser.parse('(1 2 (3 4 5 6) (7 8 9))'), {})


__END__
;(a b (c d ... e . f) ...)
(a ...)
; (a b (c d ...) ...)
