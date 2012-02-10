class LecturesController < ApplicationController
  LECTURES_INDEX = Rails.root.join('public/lectures/index.yml')

  def index
    @lectures = if LECTURES_INDEX.exist?
      YAML.load_file(LECTURES_INDEX)
        .sort_by { |index, attributes| index }
        .map { |index, attributes| attributes.with_indifferent_access }
        .map { |attributes| Lecture.new(attributes) }
    else
      nil
    end

    respond_to do |format|
      format.html
      format.rss { response.headers['Content-Type'] = 'application/rss+xml; charset=utf-8' }
    end
  end

  private
  class Lecture
    attr_accessor :title, :url, :created_at

    def initialize(lecture)
      @title = lecture[:title].sub /^\d+\.\s+/, ''
      @url = (lecture.has_key?(:slug) and "/lectures/#{lecture[:slug]}") or lecture[:url]
      @created_at = lecture[:date]
    end
  end
end
