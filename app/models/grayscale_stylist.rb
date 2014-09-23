class GrayscaleStylist
  def css_filters_for_points(points)
    return [] unless grayscale_user_thumbnails?

    user_progress = points.to_f / points_required_for_fully_colored_image * 100
    grayscale_level = [100 - user_progress, 0].max

    ["-webkit-filter", "-moz-filter", "filter"].map do |filter_type|
      "#{filter_type}: grayscale(#{grayscale_level}%);"
    end
  end

  private

  def grayscale_user_thumbnails?
    Rails.application.config.try(:grayscale_user_thumbnails, false)
  end

  def points_required_for_fully_colored_image
    Rails.application.config.try(:user_target_points, 100)
  end
end
