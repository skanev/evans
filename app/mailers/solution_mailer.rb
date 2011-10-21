# encoding: utf-8
class SolutionMailer < ActionMailer::Base
  include CustomPaths

  default :from => '"Ruby ФМИ" <evans@ruby.bg>', :reply_to => '"Ruby ФМИ" <fmi@ruby.bg>'

  def new_comment(comment)
    @task_name    = comment.task_name
    @comment_body = comment.body
    @solution_url = solution_url(comment.solution)

    mail :to => comment.solution.user.email,
         :subject => "Нов коментар на #{comment.task_name}"
  end
end
