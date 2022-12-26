require 'instructor'
require 'instructor_list_entry'
require 'keyword_search'
require 'bowser/http'
require 'styles/page'
require 'spinner'
require 'settings'

# List of instructors on the page
class InstructorList
  include Clearwater::Component

  #Routing targets can store state
  def initialize
    @instructors = []
    @instructor_page_text = nil
  end
  
  def render
    if instructors.any?
      div([
        div({ 
          class: 'search-area',
        },[
          div({class: 'search-box'},
          [
            h1('Find Our People'),
            p('To refine your search select a single option or a combination of options'),
            keyword_search_field,
            city_search_field,
            state_country_select,
            certifications_select,
          ]),
        ]),
        div({ class: 'main-content' }, [
          div({ style: Page.instructor_text, innerHTML: instructor_page_text }, nil),
          ul(
            filtered_instructors.map do |instructor|
              InstructorListEntry.new(instructor)
            end
          ),
        ]),
      ])
    elsif loading_instructors?
      Spinner.new
    else
      p('Error loading instructors!')
    end
  end

  def filtered_instructors
    @keyword_search_query = '' if @keyword_search_query.nil?
    @state_country_search_query = '' if @state_country_search_query.nil?
    @certification_search_query = '' if @certification_search_query.nil?
    @city_search_query = '' if @city_search_query.nil?

    instructors.select do |instructor|
      filter_keywords(instructor) &&
      filter_state_country(instructor) &&
      filter_city(instructor) &&
      filter_certifications(instructor)
    end
  end

  def include_instructor?(include_result, search_field)
    if search_field.empty? || search_field == :filter_off
      true
    else
      include_result
    end
  end

  def filter_keywords(instructor)
    include_instructor?(KeywordSearch.match?(instructor, @keyword_search_query), @keyword_search_query)
  end

  def filter_city(instructor)
    include_instructor?(instructor.city.downcase.include?(@city_search_query.downcase), @city_search_query)
  end

  def filter_state_country(instructor)
    include_instructor?(instructor.state_country.include?(@state_country_search_query), @state_country_search_query)
  end

  def filter_certifications(instructor)
    #include_instructor?(instructor.qualified?(@certification_search_query), @certification_search_query)
    include_instructor?(instructor.certification.equal?(@certification_search_query), @certification_search_query)
  end

  def instructors
    # Lazily load instructors, but just do it once.
    if @instructors.empty? && !@loading_instructors
      @loading_instructors = true
      Bowser::HTTP.fetch(instructors_url)
        .then do |response|
        # Assumes response is an array of JSON objects
        @instructors = response.json.map { |hash| Instructor.new(hash) }
        @instructors = @instructors.reject { |instructor| !instructor.certified? }
        @loading_instructors = false
        call # Component#call re-renders all Clearwater apps on the page
      end
    end
    @instructors
  end

  def instructor_page_text
    if @instructor_page_text.nil?
      Bowser::HTTP.fetch(instructor_page_text_url)
        .then do |response|
        @instructor_page_text =  response.json.first[:instructor_text]
        call
      end
    end
    @instructor_page_text
  end

  def loading_instructors?
    @loading_instructors
  end

  # Fetch data from here
  def instructors_url
    Settings::INSTRUCTORS_URL
  end

  #Fetch Instructor Page Text
  def instructor_page_text_url
    Settings::INSTRUCTORS_TEXT
  end

  # Event handlers
  def filter_keyword_list(event)
    @keyword_search_query = event.target.value
    call # Re-render with the new filter
  end

  def filter_city_list(event)
    @city_search_query = event.target.value
    call # Re-render with the new filter
  end

  def filter_state_country_list(event)
    @state_country_search_query = event.target.value
    call
  end

  def filter_certifications_list(event)
    @certification_search_query = event.target.value
    call
  end

  #Components

  def keyword_search_field
    input(
      type: :search,
      oninput: method(:filter_keyword_list), # Filter as you type
      value: @keyword_search_query,
      placeholder: 'Keyword Search',
    )
  end

  def city_search_field
    input(
      type: :search,
      oninput: method(:filter_city_list), # Filter as you type
      value: @city_search_query,
      placeholder: 'Search Location City',
    )
  end

  def state_country_select
    select(
      { id: 'state-country-search',
      onchange: method(:filter_state_country_list) },
      [option({value: :filter_off}, 'State/Country'),
       optgroup(label: 'States'),
       state_select_options,
       optgroup(label: 'Countries'),
       country_select_options])
  end
  
  def certifications_select
    select({
      onchange: method(:filter_certifications_list) },[
      option({value: :filter_off}, 'Krav Maga Certification Level'),
      certifications_select_options
      ])
  end

  def state_select_options
    Settings::STATES.map do |state|
      option({value: state}, state)
    end
  end

  def country_select_options
    Settings::COUNTRIES.map do |country|
      option({value: country}, country)
    end
  end

  def certifications_select_options
    Instructor::CERTIFCATIONS.map do |certification|
      option({value: certification[0]}, certification[0])
    end
  end

end

