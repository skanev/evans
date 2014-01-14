module CodeFormatter
  extend self

  InlineComment = Struct.new(:text, :user)

  def format(code, comments = {})
    comments = {
      1 => [
        InlineComment.new('Hi there', User.find(1)),
        InlineComment.new('This _is_ awesome', User.find(2)),
      ],
      7 => [
        InlineComment.new(<<-END, User.find(3))
Това не изглежда никак лошо. Какво мислиш за `foo.map { |a| a.downcase! }`?

Тества ли го този код, всъщност?
        END
      ]
    }
    code = CodeRay.scan(code, Language.language).html(line_numbers: :inline, bold_every: false, line_number_anchors: false, css: :class)
    code = code.scan(/^.*\n/).map.with_index do |line, index|
      line_number = index + 1
      chunks = comments[line_number]

      text = if chunks
               chunks.map { |c| <<-END }.join
                            <div class='inline-comment'>
                              <div class='author'>
                                <img src="#{c.user.photo.url}" width="22" height="22">
                                #{c.user.full_name}
                              </div>
                              <div class='body'>
                                #{Markup.format(c.text)}
                              </div>
                            </div>
                            END
             else
               nil
             end

      result = "<div class='row'>#{line.chomp}</div>"
      result += "<div class='inline-comments'>#{text}</div>" if text
      result
    end.join
    code.html_safe
  end
end
