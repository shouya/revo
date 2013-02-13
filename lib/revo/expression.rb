#

module Revo
  module Expression
    # Virtual method
    def eval(scope)
      raise "Undefined eval method for `#{self.class.to_s}' class"
    end
  end
end
