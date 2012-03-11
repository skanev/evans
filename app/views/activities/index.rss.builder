# variables to be used from default layout
@title = 'Активност'
@items = nil

def feed_content(xml)
  @feed.each_activity do |activity|
    feed_body  = render 'activity_content', :activity => activity
    feed_title = "#{activity.user_name} #{activity.describe} решение на #{activity.subject}"

    xml.item do
      xml.title   feed_title
      xml.link    activities_path
      xml.description { xml.cdata! Markup.format(feed_body) }
      xml.tag!('content:encoded') { xml.cdata! Markup.format(feed_body) }
      xml.pubDate activity.happened_at.rfc2822
      xml.guid    activities_path
    end
  end
end

