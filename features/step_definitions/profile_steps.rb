Когато 'кача снимка' do
  visit edit_profile_path
  attach_file 'user[photo]', file_fixture('mind_flayer.jpg')
  click_button 'Запази'
end

То 'трябва да имам снимка в профила си' do
  current_user.reload.photo.url.should be_present
end
