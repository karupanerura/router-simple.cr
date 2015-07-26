require "./spec_helper"

describe Router::Simple::PathSpec do
  it "Match path" do
    Router::Simple::PathSpec.new("/").match("/").should be_a(MatchData)
    Router::Simple::PathSpec.new("/").match("/foo").should be_nil
    Router::Simple::PathSpec.new("/foo").match("/").should be_nil
    Router::Simple::PathSpec.new("/foo").match("/foo").should be_a(MatchData)
  end

  it "Match parametalized path" do
    Router::Simple::PathSpec.new("/:foo/foo").match("/").should be_nil
    Router::Simple::PathSpec.new("/:foo/foo").match("/bar/foo").should be_a(MatchData)
    Router::Simple::PathSpec.new("/:foo/foo").match("/baz/foo").should be_a(MatchData)
    Router::Simple::PathSpec.new("/:foo/foo").match("/foo/bar").should be_nil
    Router::Simple::PathSpec.new("/foo/:bar").match("/").should be_nil
    Router::Simple::PathSpec.new("/foo/:bar").match("/foo/").should be_nil
    Router::Simple::PathSpec.new("/foo/:bar").match("/foo/bar").should be_a(MatchData)
    Router::Simple::PathSpec.new("/foo/:bar").match("/foo/baz").should be_a(MatchData)
  end
end

describe Router::Simple::Route(String) do
  it "has getter for spec/meta." do
    route = Router::Simple::Route(String).new(Router::Simple::PathSpec.new("/"), "meta")
    route.spec.pattern.should eq("/")
    route.meta.should eq("meta")
  end

  it "can match to path." do
    route = Router::Simple::Route(String).new(Router::Simple::PathSpec.new("/"), "meta")
    route.match("/").should be_a(MatchData)
    route.match("/foo").should be_nil
    route.match?("/").should be_true
    route.match?("/foo").should be_false
  end
end

describe Router::Simple::Result(String) do
  it "can create result object." do
    route = Router::Simple::Route(String).new(Router::Simple::PathSpec.new("/:foo/foo"), "meta")
    match = route.match("/bar/foo").not_nil!
    result = Router::Simple::Result(String).new(match, route)
    result.match.should eq match
    result.route.should eq route
  end
end

describe Router::Simple::Routes(String) do
  it "can add rotue." do
    routes = Router::Simple::Routes(String).new()
    routes.add("/", "meta")
  end

  it "can match rotue." do
    routes = Router::Simple::Routes(String).new()
    routes.add("/",         "root")
    routes.add("/foo",      "foo")
    routes.add("/foo/:bar", "foo-bar")

    routes.match("/") {|result|
      result.route.meta.should eq("root")
    }.should be_true
    routes.match("/foo") {|result|
      result.route.meta.should eq("foo")
    }.should be_true
    routes.match("/foo/barbar") {|result|
      result.route.meta.should eq("foo-bar")
      result.match["bar"].should eq("barbar")
    }.should be_true
    routes.match("/bar") {|result|
      raise "no reach here"
    }.should be_false
  end
end
