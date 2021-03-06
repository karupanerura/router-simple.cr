require "./router-simple/*"

module Router::Simple
 class Dispatcher(T)
   @routes :: Array(Route(T))

   def initialize()
     @routes = [] of Route(T)
   end

   def add(pattern : String, meta : T)
     spec = PathSpec.new(pattern)
     add(spec, meta)
   end

   def add(spec : PathSpec, meta : T)
     @routes << Route(T).new(spec, meta)
   end

   def match(uri : URI, &block) : Bool
     self.match(uri.path, block)
   end

   def match(path : String, &block) : Bool
     @routes.each{|route|
       match = route.match(path)
       if match != nil
         result = Result(T).new(match.not_nil!, route)
         yield result
         return true
       end
     }
     return false
   end
 end
end
