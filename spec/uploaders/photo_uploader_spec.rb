require 'spec_helper'
require 'carrierwave/test/matchers'

describe PhotoUploader do
  include CarrierWave::Test::Matchers

  before do
    PhotoUploader.enable_processing = true
    @uploader = PhotoUploader.new(Factory(:user), :photo)
    @uploader.store! File.open(fixture_file('beholder.jpg'))
  end

  after do
    PhotoUploader.enable_processing = false
  end

  it "creates a 150x150 thumbnail" do
    @uploader.thumb.should have_dimensions(150, 150)
  end
end
