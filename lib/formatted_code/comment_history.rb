module FormattedCode
  class CommentHistory
    class Version < Struct.new(:code, :comments_by_line)
    end

    def initialize
      @versions = []
    end

    def add_version(code, comments_by_line)
      @versions << Version.new(code, comments_by_line)
    end

    def last_version
      @versions.last
    end

    def combined_comments
      old_version = @versions.first
      comments    = old_version.comments_by_line

      @versions.drop(1).each do |version|
        diff = diff_code(old_version.code, version.code)

        comments = select_active_comments(diff, comments)
        comments = merge_comment_hashes(comments, version.comments_by_line)

        old_version = version
      end

      comments
    end

    private

    def diff_code(old_code, new_code)
      Differ.new(old_code, new_code).changes
    end

    def select_active_comments(diff, comments_by_line)
      diff.select(&:unchanged?).map do |change|
        comments_for_line = comments_by_line.fetch(change.old_position, [])

        comments_for_line.any? ? [change.new_position, comments_for_line] : nil
      end.compact.to_h
    end

    def merge_comment_hashes(comment_hash_one, comment_hash_two)
      comment_hash_one.merge(comment_hash_two) { |_, a, b| a + b }
    end
  end
end
