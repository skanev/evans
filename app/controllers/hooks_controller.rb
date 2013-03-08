class HooksController < ApplicationController
  before_filter :require_admin, only: :index
  before_filter :validate_secret_key, except: :index

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

  private

  def validate_secret_key
    raise 'Come on, set up a secret key!' if Rails.application.config.hooks_secret_key.blank?
    raise 'Somebody is being clever' if params[:key] != Rails.application.config.hooks_secret_key
  end
end
