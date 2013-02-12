#

require_relative '../revo'
require 'ap'

ap Revo::Parser.parse(DATA.read).to_s
__END__
(1 2 3 . 4)
