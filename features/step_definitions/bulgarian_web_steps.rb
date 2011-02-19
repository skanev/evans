Когато /^отида на (.*)$/ do |page_name|
  visit path_to(page_name)
end

Когато 'попълня:' do |table|
  table.rows_hash.each do |name, value|
    fill_in name, :with => value
  end
end

Когато 'натисна "$текст"' do |text|
  click_button text
end
