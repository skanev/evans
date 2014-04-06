require 'spec_helper'

describe Attribution do
  it { should validate_presence_of :reason }
  it { should validate_presence_of :link }
  it { should allow_value('http://example.com/').for(:link) }
  it { should_not allow_value('non-url').for(:link) }
end
