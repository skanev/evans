require 'spec_helper'

describe Attribution do
  it 'requires proper link format' do
    attribution = Attribution.new link: 'random'
    attribution.should have_error_on :link
  end

  it 'accepts proper link format' do
    attribution = Attribution.new link: 'http://example.com'
    attribution.should_not have_error_on :link
  end
end
