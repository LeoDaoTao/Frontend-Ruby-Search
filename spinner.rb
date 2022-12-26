class Spinner
  include Clearwater::Component

  def render
    div({ class: :spinner }, [
      div({ class: :bounce1 }, nil),
      div({ class: :bounce2 }, nil),
      div({ class: :bounce3 }, nil),
    ])
  end
end
