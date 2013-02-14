#

require_relative '../revo'
require_relative 'callable/syntax_rule'


require 'ap'

include Revo

rt = Runtime.new
# rt.eval(Parser.parse(DATA.read))
ap syntax = SyntaxRule.new([], Parser.parse(DATA.read), '')

ap syntax.pattern.match(Parser.parse('(1 2 (2 3 3 4) (3 2 1))'), {})


__END__
; (my god (oh yeah ... no . xxx) ...)
(my god (oh yeah ...) ...)
