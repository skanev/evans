class UserPhotoService
  class UserPhotoBuilder
    include ActionView::Helpers::AssetTagHelper

    def initialize()
      @css_styles = []
      @css_classes = []
    end

    def from_path(path)
      @image_path = path
      self
    end

    def for_avatar
      @css_classes << "avatar"
      self
    end

    def outlining_user_status(user)
      @css_classes << "admin" if user.admin?
      self
    end

    def colored_depending_on_points(points)
      @css_styles += grayscale_filters_for_points(points) if grayscale_user_thumbnails?
      self
    end

    def to_image
      image_tag @image_path, class: @css_classes, style: @css_styles.join
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

  def build_photo
    UserPhotoBuilder.new
  end
end
