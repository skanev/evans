# encoding: utf-8
Дадено 'че съществува свободен ваучър "$code"' do |code|
  create :voucher, code: code
end

Когато 'добавя следните ваучъри:' do |codes|
  visit new_voucher_path
  fill_in 'Кодове', with: codes
  click_on 'Създай'
end

Когато 'въведа ваучър "$code"' do |code|
  visit new_voucher_claim_path
  fill_in 'Код', with: code
  click_on 'Въведи'
end

То 'трябва да съществуват следните ваучъри:' do |table|
  visit vouchers_path

  codes = all('table tr td:first-child').map { |element| [element.text] }

  table.diff! codes
end

То /^трябва да имам "(\d+)" точк(?:а|и) от ваучъри$/ do |count|
  Voucher.where(user_id: @current_user.id).count.should eq count.to_i
end
