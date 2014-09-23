module ThumbnailsHelper
  def breakdown_thumbnail(breakdown, version = :size30)
    photo_path = if breakdown.photo.zero?
                   "photoless-user/#{version}.png"
                 else
                   "/uploads/photos/#{breakdown.id}/#{version}_photo.jpg"
                 end

    UserPhotoService.new.build_photo
                        .from_path(photo_path)
                        .colored_depending_on_points(breakdown.total)
                        .to_image
  end

  def user_thumbnail(user, version = :size150)
    photo_path = user.photo.try(:url, version) || image_path("photoless-user/#{version}.png")
    user_points = user.admin? ? 0 : user.points

    UserPhotoService.new.build_photo
                        .from_path(photo_path)
                        .for_avatar
                        .outlining_user_status(user)
                        .colored_depending_on_points(user_points)
                        .to_image
  end
end
