class UserPhotoService
  class UserPhotoBuilder
    include ActionView::Helpers::AssetTagHelper

    def initialize(image_path, &block)
      @image_path = image_path
      @css_styles = []
      @css_classes = []

      instance_eval(&block) if block_given?
    end

    def use_for_avatar
      @css_classes << "avatar"
    end

    def outline_user_status(user)
      @css_classes << "admin" if user.admin?
    end

    def color_based_on_points(points)
      @css_styles += GrayscaleStylist.new.css_filters_for_points(points)
    end

    def to_image
      image_tag @image_path, class: @css_classes, style: @css_styles.join
    end
  end

  def photo_from_path(image_path, &block)
    photo_builder = UserPhotoBuilder.new(image_path)
    yield photo_builder
    photo_builder.to_image
  end
end
