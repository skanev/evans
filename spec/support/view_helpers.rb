module Support
  module ViewHelpers
    def have_link_to(url)
      have_selector "a[href='#{url}']"
    end
  end
end
