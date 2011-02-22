module Support
  module GeneralHelpers
    def fixture_file(file_name)
      Rails.root.join('spec/fixtures/files', file_name)
    end
  end
end
