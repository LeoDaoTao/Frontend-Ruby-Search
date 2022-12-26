module Settings
  #check if we are in dev env
  #dev_env = Bowser.window.location.href.include?('dev')

  #if dev_env
    INSTRUCTORS_URL  = '../wp-json/api/instructors'
    INSTRUCTORS_TEXT = '../wp-json/api/instructors/instructor_text'
  #else
  #  INSTRUCTORS_URL = '../wp-json/api/instructors'
  #  INSTRUCTORS_TEXT = '../wp-json/api/instructors/instructor_text'
  #end

  STATES = %w(Alaska Alabama Arkansas American\ Samoa Arizona California Colorado Connecticut District\ of\ Columbia Delaware Florida Georgia Guam Hawaii Iowa Idaho Illinois Indiana Kansas Kentucky Louisiana Massachusetts Maryland Maine Michigan Minnesota Missouri Mississippi Montana North\ Carolina North\ Dakota Nebraska New\ Hampshire New\ Jersey New\ Mexico Nevada New\ York Ohio Oklahoma Oregon Pennsylvania Puerto\ Rico Rhode\ Island South\ Carolina South\ Dakota Tennessee Texas Utah Virginia Virgin\ Islands Vermont Washington Wisconsin West\ Virginia Wyoming)

  COUNTRIES = %w(Canada Greece Mexico Puerto\ Rico Belgium France Ireland Poland Spain Netherlands Luxembourg Japan Peru United\ Kingdom)
end
