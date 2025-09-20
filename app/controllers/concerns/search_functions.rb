module SearchFunctions
  extend ActiveSupport::Concern

  def search_action(searches, keywords, table)
    keywords = keywords.split(/[[:blank:]]+/)
    keywords.each do |keyword|
      next if keyword == ""
      keyword = "%" + searches.sanitize_sql_like(keyword) + "%"
      case table
      when User.name || Event.name
        searches = searches.where(["name LIKE? OR introduction LIKE?", keyword, keyword])
      when Comment.name
        searches = searches.where("content LIKE?", keyword)
      end
    end

    unless searches.empty?
      case table
      when User.name || Comment.name
        searches.order(cerate_at: :desc)
      when Event.name
        searches.asc_datetime_order
      end
    end

    return searches
  end
end
