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
ap match = syntax.pattern.match(lisp.cdr.cdr.car, {}, Scope.new(nil))
puts 'expansion:'
ap syntax.template.expand(match)



# Format:
#  * 1st cons: pattern
#  * 2nd cons: template
#  * 3rd cons: test list
#

__END__
(
 (letrec ((variable init) ...) body ...)
 ((lambda () (define variable init) ... body ...))
)
