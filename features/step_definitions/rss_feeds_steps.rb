# encoding: utf-8
Дадено /^имам достъп до секция Новини$/ do
  # ок, всеки има достъп до тази секция
end

Когато /^посетя секция Новини$/ do
  visit announcements_path
end
