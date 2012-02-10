shared_examples_for "RSS page" do |resourse|
  it "returns an RSS feed" do
    get :index, :format => "rss"

    response.should be_success
    response.should render_template("#{resourse}/index")
    response.content_type.should == "application/rss+xml"
  end
end

shared_examples_for "has RSS feed" do
  let (:rss_image_selector) { "img[src='#{rss_image_path}']" }
  let (:rss_link_selector)  { "a[href='#{rss_url}']"         }

  before { render }

  it ("shows the rss image") { rendered.should have_selector(rss_image_selector) }

  it ("shows the rss link") { rendered.should have_selector(rss_link_selector) }
end
