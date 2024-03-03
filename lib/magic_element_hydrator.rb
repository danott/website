class MagicElementHydrator
  attr_reader :content
  attr_reader :data

  def initialize(content:, data:)
    @content = content
    @data = data
  end

  def hydrate
    next_magic_element.present? ? self.next.hydrate : self
  end

  def next_magic_element
    EvalRuby.recognize(content, self) || IncludeInHeader.recognize(content)
  end

  def next
    fail "No more hydrating to do!" if next_magic_element.nil?
    return self.class.new(content: next_magic_element.result, data: data)
  end

  private

  class IncludeInHeader
    attr_reader :content
    attr_reader :match

    def self.recognize(content)
      match = content.match(%r{<include-in-header>(.*?)</include-in-header>}m)
      new(content:, match:) if match
    end

    def initialize(content:, match:)
      @content = content
      @match = match
    end

    def end_of_head
      content.index("</head>")
    end

    def entire_magic_element
      match[0]
    end

    def children
      match[1]
    end

    def result
      content.sub(entire_magic_element, "").insert(end_of_head, children)
    end
  end

  class EvalRuby
    attr_reader :content
    attr_reader :hydrator
    attr_reader :match

    def self.recognize(content, hydrator)
      match = content.match(%r{<eval-ruby>(.*?)</eval-ruby>}m)
      new(content:, match:, hydrator:) if match
    end

    def initialize(content:, match:, hydrator:)
      @content = content
      @match = match
      @hydrator = hydrator
    end

    def entire_magic_element
      match[0]
    end

    def ruby_code
      match[1]
    end

    # Eval in the context of hydrator to have access to data
    def replacement
      hydrator.instance_eval(ruby_code).to_s
    end

    def result
      position = content.index(entire_magic_element)
      content.sub(entire_magic_element, "").insert(position, replacement)
    end
  end
end
