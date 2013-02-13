#

module Revo
  class Symbol
    include Value

    def initialize(val)
      super(val.to_s)
    end
  end
end
