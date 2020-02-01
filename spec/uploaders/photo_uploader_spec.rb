require 'spec_helper'
require 'carrierwave/test/matchers'

describe PhotoUploader do
  include CarrierWave::Test::Matchers

  before :all do
    PhotoUploader.enable_processing = true
    @uploader = PhotoUploader.new build(:user), :photo
    @uploader.store! File.open(fixture_file('beholder.jpg'))
  end

  after :all do
    PhotoUploader.enable_processing = false
  end

  it "creates a 150x150 thumbnail" do
    expect(@uploader.size150).to have_dimensions(150, 150)
  end

  it "creates a 80x80 thumbnail" do
    expect(@uploader.size80).to have_dimensions(80, 80)
  end

  it "creates a 50x50 thumbnail" do
    expect(@uploader.size50).to have_dimensions(50, 50)
  end

  it "creates a 30x30 thumbnail" do
    expect(@uploader.size30).to have_dimensions(30, 30)
  end
end
