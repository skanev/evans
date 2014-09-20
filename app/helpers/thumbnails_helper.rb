module ThumbnailsHelper
  def breakdown_thumbnail(breakdown, version = :size30)
    image = if breakdown.photo.zero?
              "photoless-user/#{version}.png"
            else
              "/uploads/photos/#{breakdown.id}/#{version}_photo.jpg"
            end

    css_styles = []
    css_styles += grayscale_filters_for_points(breakdown.total) if grayscale_user_thumbnails?

    image_tag image, alt: breakdown.name, style: css_styles.join
  end

  def user_thumbnail(user, version = :size150)
    image = user.photo.try(:url, version) || image_path("photoless-user/#{version}.png")

    css_classes = %w(avatar)
    css_classes << "admin" if user.admin?

    css_styles = []
    css_styles += grayscale_filters_for_points(user.points) if grayscale_user_thumbnails? and not user.admin?

    image_tag image, alt: user.name, class: css_classes, style: css_styles.join
  end

  private

  def grayscale_user_thumbnails?
    Rails.application.config.try(:grayscale_user_thumbnails, false)
  end

  def points_required_for_fully_colored_image
    Rails.application.config.try(:user_target_points, 100)
  end

  def grayscale_filters_for_points(points)
    user_progress = points.to_f / points_required_for_fully_colored_image * 100
    grayscale_level = [100 - user_progress, 0].max

    ["-webkit-filter", "-moz-filter", "filter"].map do |filter_type|
      "#{filter_type}: grayscale(#{grayscale_level}%);"
    end
  end
end
