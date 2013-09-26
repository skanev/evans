require 'spec_helper'

describe Attribution do
  it { should allow_value('http://example.com/').for(:link) }
  it { should_not allow_value('non-url').for(:link) }
end
