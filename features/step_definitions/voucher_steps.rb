Дадено 'че съществува свободен ваучър "$code"' do |code|
  Factory(:voucher, :code => code)
end

То 'трябва да виждам следните ваучъри:' do |table|
  table.diff! tableish('table tr', 'th, td')
end

То /^трябва да имам "(\d+)" точк(?:а|и) от ваучъри$/ do |count|
  Voucher.where(:user_id => @current_user.id).count.should == count.to_i
end
