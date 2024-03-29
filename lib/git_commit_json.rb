# Generate a minimal JSON structure from git commits.
#
# https://gist.github.com/varemenos/e95c2e098e657c7688fd#gistcomment-3542030
# This prior art was helpful.
#
# https://git-scm.com/docs/pretty-formats
# The git pretty formats docs will be helpful if more details are ever desired.
class GitCommitJson
  def self.generate(limit = 1000)
    desired_json_structure = {
      "body" => "%b",
      "date" => "%cI",
      "hash" => "%H",
      "subject" => "%s"
    }.freeze

    ordered_attribute_keys = desired_json_structure.keys
    ordered_attribute_value_placeholders = desired_json_structure.values

    attribute_separator =
      "🤞 I pledge to never type this in a git commit, lest I break my rudimentary parser"
    commit_separator =
      "...Same goes for this, because of the aforementioned parser breaking risks 🙃"

    git_format =
      ordered_attribute_value_placeholders.join(attribute_separator) +
        commit_separator
    log = `git log -n #{limit} --format="#{git_format}"`

    log
      .strip
      .chomp(commit_separator)
      .split(commit_separator)
      .map do |commit|
        ordered_attribute_values = commit.strip.split(attribute_separator)
        Hash[ordered_attribute_keys.zip(ordered_attribute_values)]
      end
  end
end
