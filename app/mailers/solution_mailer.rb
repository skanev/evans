# encoding: utf-8
class SolutionMailer < ActionMailer::Base
  include CustomPaths

  default from: ENV['MAILER_FROM'], reply_to: ENV['MAILER_REPLY_TO']

  def new_comment(comment)
    @task_name      = comment.task_name
    @commenter_name = comment.user_name
    @comment_body   = comment.body
    @solution_url   = solution_url(comment.solution)

    mail to: comment.solution.user.email,
         subject: "Нов коментар на #{comment.task_name}"
  end
end
