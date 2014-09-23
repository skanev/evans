class UserPhotoGenerator
  include ActionView::Helpers::AssetTagHelper

  def generate_photo(image_path: image_path, user_points: points, css_classes: [], css_styles: [])
    css_styles += css_filters_for_points(user_points)

    image_tag image_path, class: css_classes, style: css_styles.join
  end

  private

  def css_filters_for_points(points)
    return [] unless grayscale_user_thumbnails?

    user_progress = points.to_f / points_required_for_fully_colored_image * 100
    grayscale_level = [100 - user_progress, 0].max

    ["-webkit-filter", "-moz-filter", "filter"].map do |filter_type|
      "#{filter_type}: grayscale(#{grayscale_level}%);"
    end
  end

  def grayscale_user_thumbnails?
    Rails.application.config.try(:grayscale_user_thumbnails, false)
  end

  def points_required_for_fully_colored_image
    Rails.application.config.try(:user_target_points, 100)
  end
end
