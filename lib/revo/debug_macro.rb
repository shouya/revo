#

require_relative '../revo'
require_relative 'callable/syntax_rule'


require 'ap'

include Revo

rt = Runtime.new
# rt.eval(Parser.parse(DATA.read))

lisp = Parser.parse(DATA.read)
syntax = SyntaxRule.new([],
                        lisp.car,     # pattern
                        lisp.cdr.car)  # template
puts 'pattern:'
ap syntax.pattern
puts 'template:'
ap syntax.template
puts 'ellipsis_vars:'
ap syntax.ellipsis_vars
puts 'match:'
ap match = syntax.pattern.match(lisp.cdr.cdr.car, {})
puts 'expansion:'
ap syntax.template.expand(match)

# ap syntax.pattern.match(Parser.parse('(1 2 (3 4 5 6) (7 8 9))'), {})


__END__
((a b (c d ... e . f) ... _ 42 g)
 (g b (f e d ... c) ... a)
 (1 2 (3 4 5 6 . 7) (8 9 10 11) 12 42 13)
)
