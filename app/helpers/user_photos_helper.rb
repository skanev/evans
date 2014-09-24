module UserPhotosHelper
  def user_photo_for_breakdown(breakdown, version = :size30)
    image_path = if breakdown.photo.zero?
                   "photoless-user/#{version}.png"
                 else
                   "/uploads/photos/#{breakdown.id}/#{version}_photo.jpg"
                 end

    UserPhotoGenerator.new.generate_photo image_path: image_path,
                                          grayscale_photo: true,
                                          user_points: breakdown.total
  end

  def user_photo_for_avatar(user, version = :size150)
    image_path = user.photo.try(:url, version) || image_path("photoless-user/#{version}.png")

    css_classes = %w(avatar)
    css_classes << "admin" if user.admin?

    UserPhotoGenerator.new.generate_photo image_path: image_path,
                                          grayscale_photo: !user.admin?,
                                          user_points: user.points,
                                          css_classes: css_classes
  end
end
