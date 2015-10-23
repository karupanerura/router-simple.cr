module Router::Simple
  class PathSpec
    getter :pattern

    @regex :: Regex

    def initialize(@pattern : String)
      regex_src = pattern
      regex_src = regex_src.gsub(/\*/) {|str, match| "\\E(?<__splat__>.+)\\Q" }
      regex_src = regex_src.gsub(/:([A-Za-z0-9_]+)/) {|str, match| "\\E(?<#{Regex.escape(match[1])}>[^/]+)\\Q" }
      regex_src = regex_src.gsub(/\{((?:\{[0-9,]+\}|[^{}]+)+)\}/) {|str, match|
        pairs = match[1].split(':')
        if pairs.size == 2
          name    = pairs[0]
          pattern = pairs[1]
          "\\E(?<#{Regex.escape(name)}>#{pattern})\\Q"
        else
          "\\E(?<#{Regex.escape(match[1])}>[^/]+)\\Q"
        end
      }
      @regex = Regex.new("^\\Q" + regex_src + "\\E$")
    end

    def match(path : String) : Regex::MatchData?
      @regex.match(path)
    end
  end
end
