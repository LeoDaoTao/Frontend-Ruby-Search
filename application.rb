require 'opal'
require 'clearwater'

require 'layout'
require 'instructor_list'

router = Clearwater::Router.new do
  route 'instructor' => InstructorList.new
end

app = Clearwater::Application.new(
  component: Layout.new,
  router: router,
  element: Bowser.document['#instructors_app']
)
app.call
