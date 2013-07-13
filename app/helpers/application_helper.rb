module ApplicationHelper
  def asset_exist?(filename)
    Rails.application.assets.find_asset(filename).nil?
  end
end
