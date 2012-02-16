# encoding: utf-8

require 'spec_helper'

describe "activities/index.rss.builder" do
  let(:feed) { Feed.new }

  before do
    view.stub :each_activity => []
    assign :feed, feed
    render :template => 'activities/index.rss.builder', :layout => 'layouts/application.rss.builder'
  end

  it ("shows correct title") { rendered.should contain(rss_title("Активност")) }

end
