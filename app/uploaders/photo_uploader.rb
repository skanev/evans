class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  version(:thumb) { resize_to_fill(150, 150) }

  def store_dir
    "uploads/photos/#{model.id}"
  end
end
