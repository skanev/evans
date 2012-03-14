xml.instruct! :xml, :version => "1.0", :encoding => 'UTF-8'
xml.rss 'version' => '2.0', 'xmlns:dc' => 'http://purl.org/dc/elements/1.1/', 'xmlns:content' => 'http://purl.org/rss/1.0/modules/content' do
  xml.channel do
    xml.title       "Програмиране с Ruby :: #{@title}"
    xml.link        'http://fmi.ruby.bg/'
    xml.description "#{@title} към курса \"Програмиране с Ruby\""
    xml.language    'bg-BG'

    @items.present? and @items.each do |item|
      item_title = item.respond_to?(:title)     ? item.title      : feed_title(item)
      item_link  = item.respond_to?(:url)       ? item.url        : feed_path(item)
      item_body  = item.respond_to?(:body)      ? item.body       : feed_body(item)
      item_date  = item.respond_to?(:created_at)? item.created_at : feed_date(item)

      xml.item do
        xml.title   item_title
        xml.link    item_link
        xml.description { xml.cdata! Markup.format(item_body) }
        xml.tag!('content:encoded') { xml.cdata! Markup.format(item_body) }
        xml.pubDate item_date.rfc2822
        xml.guid    item_link
      end
    end
  end
end

