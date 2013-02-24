# -*- scheme -*-

require_relative '../revo'
require 'ap'

include Revo

rt = Runtime.new
ap rt.eval(Parser.parse(DATA.read))

__END__
(define laz (delay (+ 1 2)))
;Value: laz

laz
;Value 11: #[promise 11]

(promise? laz)
;Value: #t

(force laz)
;Value: 3

(* 10 (force laz))
;Value: 30
