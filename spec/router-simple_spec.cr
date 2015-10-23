require "./spec_helper"

describe Router::Simple::PathSpec do
  it "Match path" do
    Router::Simple::PathSpec.new("/").match("/").should be_a(Regex::MatchData)
    Router::Simple::PathSpec.new("/").match("/foo").should be_nil
    Router::Simple::PathSpec.new("/foo").match("/").should be_nil
    Router::Simple::PathSpec.new("/foo").match("/foo").should be_a(Regex::MatchData)
  end

  it "Match parametalized path" do
    # /:foo
    Router::Simple::PathSpec.new("/:foo/foo").match("/").should be_nil
    Router::Simple::PathSpec.new("/:foo/foo").match("/bar/foo").should be_a(Regex::MatchData)
    Router::Simple::PathSpec.new("/:foo/foo").match("/baz/foo").should be_a(Regex::MatchData)
    Router::Simple::PathSpec.new("/:foo/foo").match("/foo/bar").should be_nil
    Router::Simple::PathSpec.new("/foo/:bar").match("/").should be_nil
    Router::Simple::PathSpec.new("/foo/:bar").match("/foo/").should be_nil
    Router::Simple::PathSpec.new("/foo/:bar").match("/foo/bar").should be_a(Regex::MatchData)
    Router::Simple::PathSpec.new("/foo/:bar").match("/foo/baz").should be_a(Regex::MatchData)

    # /{foo}
    Router::Simple::PathSpec.new("/{foo}/foo").match("/").should be_nil
    Router::Simple::PathSpec.new("/{foo}/foo").match("/bar/foo").should be_a(Regex::MatchData)
    Router::Simple::PathSpec.new("/{foo}/foo").match("/baz/foo").should be_a(Regex::MatchData)
    Router::Simple::PathSpec.new("/{foo}/foo").match("/foo/bar").should be_nil
    Router::Simple::PathSpec.new("/foo/{bar}").match("/").should be_nil
    Router::Simple::PathSpec.new("/foo/{bar}").match("/foo/").should be_nil
    Router::Simple::PathSpec.new("/foo/{bar}").match("/foo/bar").should be_a(Regex::MatchData)
    Router::Simple::PathSpec.new("/foo/{bar}").match("/foo/baz").should be_a(Regex::MatchData)

    # /{foo:[0-9]{2}}
    Router::Simple::PathSpec.new("/{foo:[0-9]{2}}/foo").match("/").should be_nil
    Router::Simple::PathSpec.new("/{foo:[0-9]{2}}/foo").match("/bar/foo").should be_nil
    Router::Simple::PathSpec.new("/{foo:[0-9]{2}}/foo").match("/12/foo").should be_a(Regex::MatchData)
    Router::Simple::PathSpec.new("/{foo:[0-9]{2}}/foo").match("/foo/bar").should be_nil
    Router::Simple::PathSpec.new("/foo/{bar:[0-9]{2}}").match("/").should be_nil
    Router::Simple::PathSpec.new("/foo/{bar:[0-9]{2}}").match("/foo/").should be_nil
    Router::Simple::PathSpec.new("/foo/{bar:[0-9]{2}}").match("/foo/34").should be_a(Regex::MatchData)
    Router::Simple::PathSpec.new("/foo/{bar:[0-9]{2}}").match("/foo/baz").should be_nil

    # /foo/*
    Router::Simple::PathSpec.new("/*").match("/").should be_nil
    Router::Simple::PathSpec.new("/*").match("/bar/foo").should be_a(Regex::MatchData)
    Router::Simple::PathSpec.new("/foo/*").match("/").should be_nil
    Router::Simple::PathSpec.new("/foo/*").match("/foo/").should be_nil
    Router::Simple::PathSpec.new("/foo/*").match("/foo/waiwai").should be_a(Regex::MatchData)
    Router::Simple::PathSpec.new("/foo/*").match("/foo/waiwai/gayagaya").should be_a(Regex::MatchData)

    # Mixed
    Router::Simple::PathSpec.new("/xyz/:foo/{bar}/{baz:[0-9]{2}}/*").match("/").should be_nil
    Router::Simple::PathSpec.new("/xyz/:foo/{bar}/{baz:[0-9]{2}}/*").match("/xyz/foo/bar/09/baz").should be_a(Regex::MatchData)
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
    route.match("/").should be_a(Regex::MatchData)
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

describe Router::Simple::Dispatcher(String) do
  it "can add rotue." do
    dispatcher = Router::Simple::Dispatcher(String).new()
    dispatcher.add("/", "meta")
  end

  it "can match rotue." do
    dispatcher = Router::Simple::Dispatcher(String).new()
    dispatcher.add("/",         "root")
    dispatcher.add("/foo",      "foo")
    dispatcher.add("/foo/:bar", "foo-bar")

    dispatcher.match("/") {|result|
      result.route.meta.should eq("root")
    }.should be_true
    dispatcher.match("/foo") {|result|
      result.route.meta.should eq("foo")
    }.should be_true
    dispatcher.match("/foo/barbar") {|result|
      result.route.meta.should eq("foo-bar")
      result.match["bar"].should eq("barbar")
    }.should be_true
    dispatcher.match("/bar") {|result|
      raise "no reach here"
    }.should be_false
  end
end
