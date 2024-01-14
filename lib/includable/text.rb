module Includable
  class Text
    attr_reader :string

    def initialize(string:, data:)
      @string = string
    end

    def render
      string
    end
  end
end
