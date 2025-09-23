module SearchFunctions
  extend ActiveSupport::Concern

  def search_action(searches, keywords, table)
    keywords = keywords.split(/[[:blank:]]+/)
    keywords.each do |keyword|
      next if keyword == ""
      keyword = "%" + searches.sanitize_sql_like(keyword) + "%"
      case table
      when User.name || Event.name || Group.name
        searches = searches.where(["name LIKE? OR introduction LIKE?", keyword, keyword])
      when Comment.name
        searches = searches.where("content LIKE?", keyword)
      end
    end

    unless searches.empty?
      case table
      when User.name || Group.name
        searches.order(name: :asc)
      when Event.name
        searches.asc_datetime_order
      when Comment.name
        searches.order(create_at: :desc)
      end
    end

    return searches
  end
end
