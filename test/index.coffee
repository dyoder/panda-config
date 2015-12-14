assert = require "assert"
Amen = require "amen"
{create, load, save} = require "../src/index.coffee"
{call} = require "fairmont"

Amen.describe "Simple YAML configuration file", (context) ->

  context.test "create", ->

    configuration = create
      paths: [ "./test" ]
      extension: ".yaml"
      format: "yaml"
      name: "settings"

    context.test "load", ->

      data = yield load configuration
      assert.equal data.foo.bar, "Hello"

      context.test "save", ->

        data.foo.bar = "Goodbye"
        yield save configuration, data

        data = yield load configuration
        assert.equal data.foo.bar, "Goodbye"

        data.foo.bar = "Hello"
        yield save configuration, data
