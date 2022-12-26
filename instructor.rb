class Instructor
  attr_reader :id, :name, :first_name, :last_name, :city, :state_country, :image,
              :school, :certification, :certification_data, :certification_value,
              :certification_url, :index_string, :qualified?, :image_data, :avatar,
              :teaching_since, :programs, :add_certifications, :bio, :deleting?

  CERTIFCATIONS = {
    'Yellow Belt Instructor' => 1,
    'Orange Belt Instructor' => 2,
    'Green Belt Instructor' => 3,
    'Blue Belt Instructor' => 4,
    'Brown Belt Instructor' => 5,
    '1st Dan Black Belt Instructor' => 6,
    '2nd Dan Black Belt Instructor' => 7,
    '3rd Dan Black Belt Instructor' => 8,
    '4th Dan Black Belt Instructor' => 9,
    '5th Dan Black Belt Instructor' => 10,
    '6th Dan Black Belt Instructor' => 11
  }

  DEFAULT_IMAGE = 'http://www.kravmaga.com/site/plugins/krav-instructors/assets/images/person.jpg'

  def initialize(attributes={})
    attributes.each do |attr, value|
      instance_variable_set "@#{attr}", value
    end
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def qualified?(level)
    self.certification_value >= level.to_i
  end

  def certified?
    !!self.certification
  end

  def certification
    self.certification_data[0][0]
  end

  def certification_url
    #TODO Find out why .to_s was needed here
    self.certification_data[1].to_s
  end

  def certification_value
    CERTIFCATIONS[certification].to_i
  end

  def keywords
    keywords = []
    keywords << self.name.split unless self.name.nil?
    keywords << self.school.split unless self.school.nil?
    keywords << self.certification.split unless self.certification.nil?
    keywords.flatten.map(&:downcase)
  end

  def index_string
    #poorman's index :) improved performance over 2 array search by about 40%
    self.keywords.join
  end

  def avatar
    if self.image_data.empty?
      DEFAULT_IMAGE.sub(/\.(?=[^.]*$)/, '-120x120.')
    else
      self.image_data.sub(/\.(?=[^.]*$)/, '-120x120.')
    end
  end

  def image
    if self.image_data.empty?
      DEFAULT_IMAGE.sub(/\.(?=[^.]*$)/, '-300x300.')
    else
      self.image_data.sub(/\.(?=[^.]*$)/, '-300x300.')
    end
  end

end

