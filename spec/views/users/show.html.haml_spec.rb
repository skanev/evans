require 'spec_helper'

describe "users/show.html.haml" do
  let(:user) { build_stubbed :user }
  let(:points_breakdown) { double('points breakdown') }

  before do
    view.stub admin?: false
    view.stub edit_profile_path: '/profile/edit'

    points_breakdown.stub :each_starred_post_with_title
    points_breakdown.stub :having_starred_posts?

    assign :user, user
    assign :points_breakdown, points_breakdown
  end

  context 'when a user is not logged in' do
    before do
      view.stub logged_in?: false
      view.stub current_user: nil
    end

    it "shows links to starred posts of the user" do
      points_breakdown.stub having_starred_posts?: true
      points_breakdown.should_receive(:each_starred_post_with_title).and_yield(build_stubbed(:reply), "Post title")
      view.stub post_path: '/post-path'

      render

      rendered.should have_selector("a[href='/post-path']:contains('Post title')")
    end

    it "doesn't show a link to the edit profile page" do
      render
      rendered.should_not have_selector("a[href='/profile/edit']")
    end
  end

  context 'when a user is logged in' do
    before do
      view.stub logged_in?: true
      view.stub current_user: user
    end

    it "shows a link to the edit profile page if viewing user's own profile" do
      render
      rendered.should have_selector("a[href='/profile/edit']")
    end

    it "doesn't show a link to the edit profile page if viewing someone else's profile" do
      assign :user, build_stubbed(:user)

      render

      rendered.should_not have_selector("a[href='/profile/edit']")
    end
  end
end
