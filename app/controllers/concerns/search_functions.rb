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
        searches = searches.order(name: :asc).page(params[:page]).per(@users_per)
      when Event.name
        searches = searches.asc_datetime_order
        searches = Kaminari.paginate_array(searches).page(params[:page]).per(@events_per)
      when Comment.name
        searches.order(create_at: :desc).page(params[:page]).per(@comments_per)
      when Group.name
        searches.order(name: :asc).page(params[:page]).per(@groups_per)
      end
    end

    return searches
  end
end
