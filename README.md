# router-simple

simple path router inspired by [Router::Simple](https://metacpan.org/pod/Router::Simple).

## Installation

Add it to `Projectfile`

```crystal
deps do
  github "karupanerura/router-simple.cr"
end
```

## Usage

```crystal
require "router-simple"

dispatcher = Router::Simple::Dispatcher(Hash(Symbol, String)).new()
dispatcher.add("/", {
  :controller => "Root",
  :action     => "index",
})
dispatcher.add("/users/:user_id", {
  :controller => "Users",
  :action     => "fetch_by_id",
})

dispatcher.match("/") {|result|
  p result.route.meta[:controller] # => "Root"
}

dispatcher.match("/users/1") {|result|
  p result.route.meta[:controller] # => "Users"
  p result.match["user_id"]        # => "1"
}
```

## Development

TODO: Write instructions for development

## Contributing

1. Fork it ( https://github.com/karupanerura/router-simple.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- karupanerura(https://github.com/karupanerura) karupanerura - creator, maintainer
