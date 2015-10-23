module Router::Simple
  class Result(T)
    getter :match, :route

    def initialize(@match : Regex::MatchData, @route : Route(T))
    end
  end
end
