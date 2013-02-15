#

require_relative '../revo'
require_relative 'callable/syntax_rule'


require 'ap'

include Revo

lisp = Parser.parse(DATA.read)

# Set keywords here:
keywords = %w[let]

syntax = SyntaxRule.new(keywords,
                        lisp.car,     # pattern
                        lisp.cdr.car)  # template
puts 'pattern:'
ap syntax.pattern
puts 'template:'
ap syntax.template
puts 'ellipsis_vars:'
ap syntax.ellipsis_vars
puts 'match:'
ap match = syntax.match(lisp.cdr.cdr.car)
puts 'expansion:'
ap syntax.template.expand(match, Scope.new(nil))



# Format:
#  * 1st cons: pattern
#  * 2nd cons: template
#  * 3rd cons: test list
#

__END__
(
 (swap op1 op2)
 (let ((tmp op1))
   (set! op1 op2)
   (set! op2 tmp))
 (swap a b)
)
