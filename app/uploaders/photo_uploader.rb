class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  process :convert_to_jpeg

  version(:size150) { resize_to_fill(150, 150) }
  version(:size80)  { resize_to_fill(80, 80) }
  version(:size50)  { resize_to_fill(50, 50) }
  version(:size30)  { resize_to_fill(30, 30) }

  def store_dir
    "uploads/photos/#{model.id}"
  end

  def filename
    'photo.jpg' if original_filename
  end

  private

  def convert_to_jpeg
    manipulate! do |image|
      image.flatten
      image.colorspace 'RGB'
      image.strip
      image.quality '100'
      image.format 'jpeg'
      image
    end
  end
end
