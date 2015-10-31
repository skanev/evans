class LecturesWorker
  include Sidekiq::Worker

  def perform
    log_file = Rails.root.join('log/lectures.log')

    unless system "bundle exec rake lectures:compile > #{log_file} 2>&1"
      SystemMailer.lectures_build_error(File.read(log_file)).deliver
    end
  end
end
