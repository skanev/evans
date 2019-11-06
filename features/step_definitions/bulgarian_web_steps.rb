То 'трябва да виждам "$text"' do |text|
  expect(page).to have_content(text)
end

То 'не трябва да виждам "$text"' do |text|
  page.should_not have_content(text)
end

И 'кво?' do
  save_and_open_page
end
