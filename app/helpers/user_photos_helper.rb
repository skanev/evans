module UserPhotosHelper
  def user_photo_for_breakdown(breakdown, version = :size30)
    photo_path = if breakdown.photo.zero?
                   "photoless-user/#{version}.png"
                 else
                   "/uploads/photos/#{breakdown.id}/#{version}_photo.jpg"
                 end

    UserPhotoService.new.photo_from_path(photo_path) do |photo|
      photo.color_based_on_points breakdown.total
    end
  end

  def user_photo_for_avatar(user, version = :size150)
    photo_path = user.photo.try(:url, version) || image_path("photoless-user/#{version}.png")
    user_points = user.admin? ? 0 : user.points

    UserPhotoService.new.photo_from_path(photo_path) do |photo|
      photo.use_for_avatar
      photo.outline_user_status user
      photo.color_based_on_points user_points
    end
  end
end
