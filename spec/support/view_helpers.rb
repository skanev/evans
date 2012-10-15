module Support
  module ViewHelpers
    RSpec::Matchers.define :have_link_to do |url|
      match do |view|
        view.should have_selector "a[href='#{url}']"
      end
    end
  end
end
