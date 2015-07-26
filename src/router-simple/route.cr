module Router::Simple
  class Route(T)
    getter :spec, :meta

    def initialize(@spec : PathSpec, @meta : T)
    end

    def match(path : String) : MatchData?
      @spec.match(path)
    end

    def match?(path : String) : Bool
      self.match(path) != nil
    end
  end
end
