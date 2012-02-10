require 'spec_helper'

describe LecturesController do

  describe "GET RSS feed" do
    it_behaves_like "RSS page", :lectures
  end

end
