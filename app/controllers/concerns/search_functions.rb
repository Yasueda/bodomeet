module SearchFunctions
  extend ActiveSupport::Concern

  def search_action(searches, keywords, table)
    keywords = keywords.split(/[[:blank:]]+/)
    keywords.each do |keyword|
      next if keyword == ""
      keyword = "%" + searches.sanitize_sql_like(keyword) + "%"
      case table
      when User.name
        searches = searches.where(["name LIKE? OR introduction LIKE?", keyword, keyword])
      when Event.name
        searches = searches.where(["name LIKE? OR introduction LIKE?", keyword, keyword])
      when Comment.name
        searches = searches.where("content LIKE?", keyword)
      when Group.name
        searches = searches.where(["name LIKE? OR introduction LIKE?", keyword, keyword])
      end
    end

    unless searches.empty?
      case table
      when User.name
        searches = searches.order(name: :asc)
      when Event.name
        searches = searches.asc_datetime_order
      when Comment.name
        searches.order(create_at: :desc)
      when Group.name
        searches.order(name: :asc)
      end
    end

    return searches
  end
end
