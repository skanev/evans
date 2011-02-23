module NavigationHelpers
  def path_to(page_name)
    case page_name
      when /страницата за регистрация/
        new_registration_path
      when /страницата със записани студенти/
        sign_ups_path
      when /заглавната страница на форумите/
        topics_path
      when /темата "(.*)"/
        topic_path Topic.find_by_title!($1)
      when /редакцията на тема "(.*?)"/
        edit_topic_path Topic.find_by_title!($1)
      when /профила си/
        profile_path
      else
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
