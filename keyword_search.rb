module KeywordSearch
  def KeywordSearch.match?(instructor, search_keywords)
    search_keywords = search_keywords.downcase.split
    search_keywords.each do |search_keyword|
      return true if instructor.index_string.include? search_keyword
    end
    false
  end
end
