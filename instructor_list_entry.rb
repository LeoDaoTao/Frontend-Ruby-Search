require 'modal'

# Individual entries into the instructor list
class InstructorListEntry
  include Clearwater::Component
  include Clearwater::CachedRender

  attr_reader :instructor

  def initialize(instructor, instructor_list)
    @instructor = instructor
    @instructor_list = instructor_list

    @deleting = instructor.deleting?
  end

  # Only re-render if the instructor has changed. This is the only invalidation
  # you need if your models are immutable.
  def should_render?(previous)
    !(
      instructor.equal?(previous.instructor) &&
      deleting? == previous.deleting?
    )
  end

  def render
    li({ 
      onclick: method(:open_modal), 
      class: 'fade-in',
      },[
      img(src: instructor.avatar),
      h2(instructor.name),
      h3(instructor.school),
    ])
  end

  def delete
    instructor.deleting? = true
    call

    #Bowser.window.delay 5000 do
    #  instructor_list.delete instructor
    #  call
    #end
  end

  def deleting?
    !!@deleting
  end

  def open_modal
    Modal.present(instructor)
    call
  end

  # The key is the unique id among sibling components so the vdom knows whether
  # a component has been moved from its previous location. Makes filtering and
  # sorting much faster because it doesn't treat them all as new components. It
  # just needs to be unique among its sibling components
  def key
    instructor.id
  end
end

