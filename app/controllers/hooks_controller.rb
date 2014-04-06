class HooksController < ApplicationController
  before_action :require_admin, only: :index
  before_action :validate_secret_key, except: :index
  skip_before_action :verify_authenticity_token

  def index
    @secret_key = Rails.application.config.hooks_secret_key
  end

  def homework
    HomeworkSyncWorker.perform_async
    render text: 'OK'
  end

  def public_homework
    HomeworkMergePublicWorker.perform_async
    render text: 'OK'
  end

  def lectures
    LecturesWorker.perform_async
    render text: 'OK'
  end

  private

  def validate_secret_key
    raise 'Come on, set up a secret key!' if Rails.application.config.hooks_secret_key.blank?
    raise 'Somebody is being clever' if params[:key] != Rails.application.config.hooks_secret_key
  end
end
