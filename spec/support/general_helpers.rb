module Support
  module GeneralHelpers
    def fixture_file(file_name)
      Rails.root.join('spec/fixtures/files', file_name)
    end

    def uploaded_photo
      File.open fixture_file('beholder.jpg')
    end

    def rss_image_path
      "/assets/rss.gif"
    end
  end
end
