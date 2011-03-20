Когато /^отида (?:на|в) (.*)$/ do |page_name|
  visit path_to(page_name)
end

Когато 'попълня:' do |table|
  table.rows_hash.each do |name, value|
    fill_in name, :with => value
  end
end

Когато /^попълня "([^"]*)" с(?:ъс)? "([^"]*)"$/ do |name, value|
  fill_in name, :with => value
end

Когато 'попълня "$field" с:' do |field, text|
  fill_in :field, :with => text
end

Когато 'натисна "$текст"' do |text|
  click_button text
end

Когато 'проследя "$text"' do |text|
  click_link text
end

То 'трябва да виждам "$text"' do |text|
  page.should have_content(text)
end

То /^трябва да съм на (.*)$/ do |page_name|
  current_path = URI.parse(current_url).path
  current_path.should == path_to(page_name)
end

И 'кво?' do
  save_and_open_page
end
