assert = require "assert"
{call} = require "when/generator"
Configurator = require "../src/index.coffee"

call ->

  try

    configurator = Configurator.make
      paths: [ "./test" ]
      extension: ".yaml"

    configuration = configurator.make name: "settings"

    yield configuration.load()

    assert.equal configuration.data.foo.bar, "Hello"

    configuration.data.foo.bar = "Goodbye"
    yield configuration.save()

    configuration.load()

    assert.equal configuration.data.foo.bar, "Goodbye"

    configuration.data.foo.bar = "Hello"
    configuration.save()

  catch error
    console.error error
