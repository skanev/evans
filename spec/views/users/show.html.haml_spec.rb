require 'spec_helper'

describe "users/show.html.haml" do
  let(:user) { build_stubbed :user, about: 'I am a platypus.' }

  before do
    allow(view).to receive(:admin?).and_return(false)
    assign :user, user
  end

  context 'when a visitor is viewing a user profile' do
    before do
      allow(view).to receive(:logged_in?).and_return(false)
      allow(view).to receive(:current_user).and_return(nil)
    end

    it "does not show a link to the edit profile page" do
      render
      expect(rendered).not_to have_link_to edit_profile_path
    end

    it "does not show the faculty number" do
      render
      expect(rendered).not_to have_content user.faculty_number
    end

    it "does not show the email" do
      render
      expect(rendered).not_to have_content user.email
    end

    it "does not show the about info" do
      render
      expect(rendered).not_to have_content user.about
    end
  end

  context 'when a user is viewing their own profile' do
    before do
      allow(view).to receive(:logged_in?).and_return(true)
      allow(view).to receive(:current_user).and_return(user)
    end

    it "shows a link to the edit profile page" do
      render
      expect(rendered).to have_link_to edit_profile_path
    end

    it "shows their faculty number" do
      render
      expect(rendered).to have_content user.faculty_number
    end

    it "does not show the email" do
      render
      expect(rendered).not_to have_content user.email
    end

    it "shows the about info" do
      render
      expect(rendered).to have_content user.about
    end
  end

  context "when a user is viewing somebody else's profile" do
    before do
      allow(view).to receive(:logged_in?).and_return(true)
      allow(view).to receive(:current_user).and_return(build_stubbed(:user))
    end

    it "does not show a link to the edit profile page" do
      render
      expect(rendered).not_to have_link_to edit_profile_path
    end

    it "does not show the faculty number" do
      render
      expect(rendered).not_to have_content user.faculty_number
    end

    it "does not show the email" do
      render
      expect(rendered).not_to have_content user.email
    end

    it "shows the about info" do
      render
      expect(rendered).to have_content user.about
    end
  end

  context 'when an admin is viewing a profile' do
    before do
      allow(view).to receive(:logged_in?).and_return(true)
      allow(view).to receive(:admin?).and_return(true)
      allow(view).to receive(:current_user).and_return(build_stubbed(:admin))
    end

    it "shows the faculty number" do
      render
      expect(rendered).to have_content user.faculty_number
    end

    it "shows the email" do
      render
      expect(rendered).to have_content user.email
    end

    it "shows the about info" do
      render
      expect(rendered).to have_content user.about
    end
  end
end
