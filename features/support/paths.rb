# encoding: utf-8
module NavigationHelpers
  def path_to(page_name)
    format = nil

    if page_name =~ /RSS адреса на/
      format = :rss
    end

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
      when /списъка с ваучъри/
        vouchers_path
      when /таблото си/
        dashboard_path
      when /новините/
        announcements_path format
      when /задачите/
        tasks_path
      when /задачата "(.*)"/
        task_path Task.find_by_name!($1)
      when /решенията на "(.*)"/
        task_solutions_path Task.find_by_name!($1), format
      when /решението на "(.*)" за "(.*)"/
        user = User.find_by_full_name! $1
        task = Task.find_by_name! $2
        solution = Solution.find_by_user_id_and_task_id! user.id, task.id
        task_solution_path solution, :task_id => task.id
      else
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
