xml.instruct! :xml, :version => "1.0", :encoding => 'UTF-8'
xml.rss 'version' => '2.0', 'xmlns:dc' => 'http://purl.org/dc/elements/1.1/', 'xmlns:content' => 'http://purl.org/rss/1.0/modules/content' do
  xml.channel do
    xml.title       'Програмиране с Ruby :: Форуми'
    xml.link        'http://fmi.ruby.bg/'
    xml.description 'Форуми към курса "Програмиране с Ruby"'
    xml.language    'bg-BG'

    if @posts.present?
      @posts.each do |post|
        xml.item do
          xml.title   post.title
          xml.link    post_path(post, :only_path => false)

          xml.description { xml.cdata! Markup.format(post.body) }
          xml.tag!('content:encoded') { xml.cdata! Markup.format(post.body) }

          xml.pubDate post.created_at.rfc2822
          xml.guid    post_path(post, :only_path => false)
        end
      end
    end
  end
end


