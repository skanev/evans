class TaskDownloadController < ApplicationController
  include ActionController::Live

  before_action :require_admin

  def create
    task_id = params[:task_id]
    task = Task.find task_id

    response.headers['Content-Disposition'] = "attachment; filename=\"homework.tar.gz\""

    TarGzipWriter.wrap(response.stream) do |tar|
      task.solutions.each do |solution|
        filename = "#{solution.user.faculty_number}.#{Language.extension}"
        code = solution.code

        tar.add_file_simple(filename, 0644, code.length) { |io| io.write(code) }
      end
    end
  ensure
    response.stream.close
  end
end
