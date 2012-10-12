require 'spec_helper'

describe "users/show.html.haml" do
  let(:user) { build_stubbed :user }

  before do
    view.stub admin?: false
    view.stub edit_profile_path: '/profile/edit'

    assign :user, user
  end

  context 'when a user is not logged in' do
    before do
      view.stub logged_in?: false
      view.stub current_user: nil
    end

    it "doesn't show a link to the edit profile page" do
      render
      rendered.should_not have_selector("a[href='/profile/edit']")
    end

    it "doesn't show the faculty number" do
      render
      rendered.should_not have_content(user.faculty_number)
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

    describe "faculty number" do
      it "is visible if viewing user's own profile" do
        render
        rendered.should have_selector(".faculty-number")
      end
      
      it "is visible if viewing someone else's profile as admin" do
        view.stub admin?: true
        assign :user, build_stubbed(:user)

        render
        rendered.should have_selector(".faculty-number")
      end

      it "is not visible if viewing someone else's profile" do
        other_user = build_stubbed(:user)
        assign :user, other_user

        render
        rendered.should_not have_content(other_user.faculty_number)
      end
    end
  end
end