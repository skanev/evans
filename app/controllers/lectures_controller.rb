class LecturesController < ApplicationController
  LECTURES_INDEX = Rails.root.join('public/lectures/index.yml')

  def index
    @lectures = if LECTURES_INDEX.exist?
      YAML.load_file(LECTURES_INDEX)
        .sort_by { |index, attributes| index }
        .map { |index, attributes| attributes.with_indifferent_access }
    else
      nil
    end

    respond_to do |format|
      format.html
      format.rss { response.headers['Content-Type'] = 'application/rss+xml; charset=utf-8' }
    end
  end
end
