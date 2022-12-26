Modal = Struct.new(:instructor) do
  include Clearwater::Component

  class << self
    attr_accessor :current
  end

  def self.present instructor
    @current = new(instructor)
  end

  def render
    div({ style: Style.modal, id: 'modal', onclick: method(:clear_modal) }, [
      div({ class: 'popup' }, [
        span({ class: 'popup-close' }, [
          span({ onclick: method(:clear_modal) }, '✖')
        ]),
        div({ class: 'photo-section' }, [
          img({ class: 'popup-instructor-image', src: instructor.image }),
          div({ class: 'instructor-since'}, [
            h4('Instructor Since:'),
            h3({ class: 'popup-teaching-since'}, instructor.teaching_since),
          ]),
        ]),
        div({ class: 'info-section'}, [
          h2(instructor.name),
          info_section('School:', instructor.school),
          info_section('City:', instructor.city),
          info_section('State/Country:', instructor.state_country),
          info_section('Krav Maga Certification Level:', link_list(instructor.certification_data), :smaller),
          info_section('Additional KMW Certifications:', link_list(instructor.add_certifications), :smaller),
          info_data(instructor.bio, :smaller),
        ]),
      ]),
    ])
  end

  def info_section(caption, data, *size)
    output = []
    unless data.nil? || data.empty?
      output << info_header(caption) 
      output << info_data(data, *size)
    end
    output
  end

  def info_header(caption)
    h4({class: 'darker'}, caption)
  end

  def info_data(data, *size)
    if size.first == :smaller
      h4(data)
    else
      h3(data)
    end
  end

  def link_list(source)
    list = []
    source.each do |item|
      name = item[0]
      url = item[1]
      list << link_list_entry(name, url) unless !url
      list << ', ' unless item.equal? source.last
    end
    list
  end

  def link_list_entry(name, url)
    unless !url
      if url.empty?
        name
      else
        a({ href: url }, name)
      end
    end
  end

  def clear_modal
    Modal.current = nil
    call
  end

  module Style
    module_function

    def modal
      {
        position: :fixed,
        top: 0,
        bottom: 0,
        right: 0,
        left: 0,
        margin: :auto,
        background_color: 'rgba(0,0,0,0.7)',
      }
    end
  end
end
