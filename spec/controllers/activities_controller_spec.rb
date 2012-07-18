require 'spec_helper'

describe ActivitiesController do
  describe "GET RSS feed" do
    log_in_as :admin

    it_behaves_like "RSS page", :activities
  end
end