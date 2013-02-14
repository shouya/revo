#

require_relative '../revo'
require 'ap'

include Revo

rt = Runtime.new
rt.eval(Parser.parse(DATA.read))

__END__
;(define (mylove) "happy valentine's day!")
;(display (mylove))
(display ((lambda () "happy valentine's day!")))
