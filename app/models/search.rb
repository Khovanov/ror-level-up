class Search
  SEARCH_OPTIONS = %w(Questions Answers Comments Users)

  def self.main(query, options = nil)
    query = Riddle::Query.escape(query)
    if options.present?
      options.singularize.constantize.search(query)
    else
      ThinkingSphinx.search query
    end
  end

  def self.params_valid?(query, options = nil)
    return false unless query.present?
    return true unless options.present?
    return true if SEARCH_OPTIONS.include?(options)
    false
  end
end