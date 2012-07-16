require 'spec_helper'

describe 'topics/_post.html.haml' do
  let(:post) { build_stubbed :topic, :created_at => Time.now }

  before do
    view.stub :post => post
    view.stub :can_edit?
    view.stub :admin?
  end

  it "renders a link to admins for toggling the post star" do
    view.stub :admin? => true
    view.stub :toggle_post_star_link => 'toggle star link'

    render

    rendered.should contain('toggle star link')
  end

  it "renders successfully" do
    render
  end
end
