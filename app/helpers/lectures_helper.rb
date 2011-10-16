module LecturesHelper
  def lecture_title(lecture)
    lecture[:title].sub /^\d+\.\s+/, ''
  end

  def lecture_url(lecture)
    if lecture[:slug]
      "/lectures/#{lecture[:slug]}"
    else
      lecture[:url]
    end
  end
end
