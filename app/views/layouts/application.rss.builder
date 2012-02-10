xml.instruct! :xml, :version => "1.0", :encoding => 'UTF-8'
xml.rss 'version' => '2.0', 'xmlns:dc' => 'http://purl.org/dc/elements/1.1/', 'xmlns:content' => 'http://purl.org/rss/1.0/modules/content' do
  xml.channel do
    xml.title       "Програмиране с Ruby :: #{@title}"
    xml.link        'http://fmi.ruby.bg/'
    xml.description "#{@title} към курса \"Програмиране с Ruby\""
    xml.language    'bg-BG'

    if @items.present?
      @items.each do |item|
        item_title = defined?(item.title)     ? item.title      : feed_title(item)
        item_link  = defined?(item.url)       ? item.url        : feed_path(item)
        item_body  = defined?(item.body)      ? item.body       : feed_body(item)
        item_date  = defined?(item.created_at)? item.created_at : feed_date(item)

        xml.item do
          xml.title   item_title
          xml.link    item_link
          xml.description { xml.cdata! Markup.format(item_body) }
          xml.tag!('content:encoded') { xml.cdata! Markup.format(item_body) }
          xml.pubDate item_date.rfc2822
          xml.guid    item_link
        end
      end
    elsif content_for?(:feed_content)
      yield :feed_content
    end
  end
end

