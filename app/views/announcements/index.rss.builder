xml.instruct! :xml, version: "1.0", encoding: 'UTF-8'
xml.rss 'version' => '2.0', 'xmlns:dc' => 'http://purl.org/dc/elements/1.1/', 'xmlns:content' => 'http://purl.org/rss/1.0/modules/content' do
  xml.channel do
    xml.title       "#{Language.course_name} :: Новини"
    xml.link        "http://#{Language.domain}/"
    xml.description "Новини за курса \"#{Language.course_name}\""
    xml.language    'bg-BG'

    @announcements.each do |announcement|
      xml.item do
        xml.title   announcement.title
        xml.link    announcement_path(announcement, only_path: false)

        xml.description { xml.cdata! Markup.format(announcement.body) }
        xml.tag!('content:encoded') { xml.cdata! Markup.format(announcement.body) }

        xml.pubDate announcement.created_at.rfc2822
        xml.guid    announcement_path(announcement, only_path: false)
      end
    end
  end
end


