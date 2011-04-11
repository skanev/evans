require 'spec_helper'

describe "users/show.html.haml" do
  let(:user) { Factory.stub(:user) }
  let(:points_breakdown) { double('points breakdown') }

  before do
    view.stub :admin? => false

    points_breakdown.stub :each_starred_post_with_title
    points_breakdown.stub :having_starred_posts?

    assign :user, user
    assign :points_breakdown, points_breakdown
  end

  it "shows a links to starred posts of the user" do
    points_breakdown.stub :having_starred_posts? => true
    points_breakdown.should_receive(:each_starred_post_with_title).and_yield(Factory.stub(:reply), "Post title")
    view.stub :post_path => '/post-path'

    render

    rendered.should have_selector("a[href='/post-path']:contains('Post title')")
  end
end
