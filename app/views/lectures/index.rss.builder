xml.instruct! :xml, :version => "1.0", :encoding => 'UTF-8'
xml.rss 'version' => '2.0', 'xmlns:dc' => 'http://purl.org/dc/elements/1.1/', 'xmlns:content' => 'http://purl.org/rss/1.0/modules/content' do
  xml.channel do
    xml.title       'Програмиране с Ruby :: Материали'
    xml.link        'http://fmi.ruby.bg/'
    xml.description 'Материали за курса "Програмиране с Ruby"'
    xml.language    'bg-BG'

    unless @lectures.nil?
      @lectures.each do |lecture|
        xml.item do
          xml.title   lecture.title
          xml.link    lecture_path(lecture, :only_path => false)
          xml.pubDate lecture.created_at.rfc2822
        end
      end
    end
  end
end
