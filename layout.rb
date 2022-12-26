require 'modal'

class Layout
  include Clearwater::Component

  def initialize
  end

  def render
    div(
      [
        outlet,
        Modal.current,
      ])
  end
end

