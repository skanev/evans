# encoding: utf-8
Дадено 'че съществува новина:' do |title|
  title, body = title.rows_hash.values_at('Заглавие', 'Тяло')
  Factory(:announcement, :title => title, :body => body)
end

То 'трябва да съществува новина "$title"' do |title|
  Announcement.where(:title => title).exists?.should be_true
end
