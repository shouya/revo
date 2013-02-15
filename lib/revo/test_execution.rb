#

require_relative '../revo'
require 'ap'

include Revo

rt = Runtime.new
ap rt.eval(Parser.parse(DATA.read))

__END__
(define-syntax foo
  (syntax-rules ()
    ((foo a b c d)
     (list a b c d)
     (display a)
     (display b)
     (display c)
     (display d))))

(foo 1 2 3 4)
