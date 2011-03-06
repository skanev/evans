То 'трябва да съществува новина "$title"' do |title|
  Announcement.where(:title => title).exists?.should be_true
end
