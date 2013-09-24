Дадено 'че съществува новина:' do |title|
  title, body = title.rows_hash.values_at('Заглавие', 'Тяло')
  create :announcement, title: title, body: body
end

Когато 'създам новина:' do |table|
  visit new_announcement_path
  fill_in_fields table
  click_on 'Публикувай'
end

Когато 'редактирам новината "$name":' do |title, table|
  announcement = Announcement.find_by_title! title

  visit edit_announcement_path announcement
  fill_in_fields table
  click_on 'Запази'
end

То 'трябва да съществува новина "$title"' do |title|
  visit announcements_path

  page.should have_content title
end
