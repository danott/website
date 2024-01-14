module Temp
  class PostMigrator
    attr_reader :path
    attr_reader :content

    def initialize(path)
      @path = path
      @content = File.read(path)
    end

    def next_path
      "site/" +
        path.delete_prefix("_scratch/old_posts/").sub(
          /\d\d\d\d-\d\d-\d\d-/,
          date_string.first(4) + "/"
        )
    end

    def date_string
      path.delete_prefix("_scratch/old_posts/").first(10)
    end

    def data_line
      wip = content.start_with?(/#[a-z]/) ? content.lines.first : ""
      wip = [date_string, wip].join(" ").strip
      "<!--data #{wip} -->\n\n"
    end

    def next_content
      lines = content.lines
      lines = lines.drop(2) if content.start_with?(/#[a-z]/)
      lines = [data_line] + lines
      lines.join.strip
    end

    def write
      FileUtils.mkdir_p(File.dirname(next_path))
      File.write(next_path, next_content)
    end
  end
end
