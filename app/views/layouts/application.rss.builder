xml.instruct! :xml, :version => "1.0", :encoding => 'UTF-8'
xml.rss 'version' => '2.0', 'xmlns:dc' => 'http://purl.org/dc/elements/1.1/', 'xmlns:content' => 'http://purl.org/rss/1.0/modules/content' do
  xml.channel do
    xml.title       "Програмиране с Ruby :: #{@title}"
    xml.link        'http://fmi.ruby.bg/'
    xml.description "#{@title} към курса \"Програмиране с Ruby\""
    xml.language    'bg-BG'

    if @items.present?
      @items.each do |item|
        xml.item do
          xml.title   item.title
          xml.link    item_path(item, :only_path => false)

          if defined? item.body
            xml.description { xml.cdata! Markup.format(item.body) }
            xml.tag!('content:encoded') { xml.cdata! Markup.format(item.body) }
          end

          xml.pubDate item.created_at.rfc2822
          xml.guid    item_path(item, :only_path => false)
        end
      end
    end
  end
end

