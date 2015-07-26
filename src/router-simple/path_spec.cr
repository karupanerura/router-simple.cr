module Router::Simple
  class PathSpec
    getter :pattern

    @regex :: Regex

    def initialize(@pattern : String)
      regex_src = pattern
      regex_src = regex_src.gsub(/(?<=\/):([^\/]+)/) {|str, match| "(?<#{Regex.escape(match[1])}>[^/]+)" }
      regex_src = regex_src.gsub(/{([^}]+)}/)        {|str, match| "(?<#{Regex.escape(match[1])}>[^/]+)" }
      @regex = Regex.new("^" + regex_src + "$")
    end

    def match(path : String) : MatchData?
      @regex.match(path)
    end
  end
end

