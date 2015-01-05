assert = require "assert"
{call} = require "when/generator"
Configurator = require "../src/index.coffee"

call ->

  try

    configurator = Configurator.make
      paths: [ "./test" ]
      extension: ".json"

    configuration = configurator.make name: "settings"
    yield configuration.load()

    data = configuration.data
    {colors, date_toJSON_timestamp, nest, quote_escape, backslash_escape} = data

    assert.deepEqual colors, ["white", "blue", "orange"]
    assert.equal date_toJSON_timestamp, "2012-04-23T18:25:43.511Z"
    # FIXME: need to run deep test
    assert.deepEqual nest,
      deeper_nest:
        deepest_nest: "smurf"
    assert.equal quote_escape, "backslash quote\""
    assert.equal backslash_escape, "backslash backslash \\"

    configuration.data.foo.bar = "Goodbye"
    yield configuration.save()

    configuration.load()

    assert.equal configuration.data.foo.bar, "Goodbye"

    configuration.data.foo.bar = "Hello"
    configuration.save()

  catch error
    console.error error
