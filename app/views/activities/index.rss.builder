# variables to be used from default layout
@title = 'Активност'
@items = nil

content_for :feed_content do
  @feed.each_activity do |activity|
    feed_body = render 'activity_content', :activity => activity
    xml.item do
      xml.title   "1"
      xml.link    activities_path
      xml.description { xml.cdata! Markup.format(feed_body) }
      xml.tag!('content:encoded') { xml.cdata! Markup.format(feed_body) }
      xml.pubDate activity.happened_at.rfc2822
      xml.guid    activities_path
    end
  end
end

