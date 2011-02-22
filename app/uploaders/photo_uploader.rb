class PhotoUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/photos/#{model.id}"
  end
end
