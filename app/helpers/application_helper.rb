module ApplicationHelper
  def asset_exist?(filename)
    !Rails.application.assets.find_asset(filename).nil?
  end
  def page_items(collection, page, page_size = 10)
    pages = (collection.size/page_size + 1).to_i
    if page.between?(1, pages)
      start_idx = (page - 1) * page_size
      end_idx = start_idx + page_size
      if page < pages
        collection[start_idx...end_idx]
      else
        collection[start_idx..-1]
      end
    else
      []
    end
  end
end
