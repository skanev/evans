# encoding: utf-8

require 'spec_helper'

describe "lectures/index.rss.builder" do

  before do
    assign :lectures, nil
    render :template => 'lectures/index.rss.builder', :layout => 'layouts/application.rss.builder'
  end

  it ("shows correct title") { rendered.should contain(rss_title("Материали")) }

end
