#

require_relative '../revo'
require 'ap'

include Revo

rt = Runtime.new
ap rt.eval(Parser.parse(DATA.read))

__END__

;(define (foo-1) '())
;(debug-scope 0)

(define global 1)

;(define trans-table (map
;                     (lambda (n)
;                       ((lambda (carry line)
;                          (for-each (lambda (x) (debug-scope 0))
;                                    '(0)))))
;                     '(0)))
(map (lambda (a b) (debug-scope 1) (+ a b)) '(2 3 4) '(4 3 2))
