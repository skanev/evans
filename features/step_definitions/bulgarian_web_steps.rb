То 'трябва да виждам "$text"' do |text|
  page.should have_content(text)
end

И 'кво?' do
  save_and_open_page
end
