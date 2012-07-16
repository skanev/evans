# encoding: utf-8
Дадено 'че съществува свободен ваучър "$code"' do |code|
  create :voucher, :code => code
end

То 'трябва да виждам следните ваучъри:' do |table|
  codes = all('table td:first-child').map { |element| [element.text] }

  table.diff! codes
end

То /^трябва да имам "(\d+)" точк(?:а|и) от ваучъри$/ do |count|
  Voucher.where(:user_id => @current_user.id).count.should == count.to_i
end
