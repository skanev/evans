class TaskMailer < ActionMailer::Base
  default from: Language.email_sender, reply_to: Language.email

  def new_task(task)
    User.where(task_notification: true).each do |user|
      TaskMailer.delay.new_task_for_user(task, user)
    end
  end

  def new_task_for_user(task, user)
    @user_name     = user.first_name
    @task_name     = task.name
    @task_url      = task_url(task)
    @task_end_date = task.closes_at.strftime('%d.%m.%Y %H:%M')

    mail to: user.email,
         subject: "Нова задача - #{task.name}"
  end
end
