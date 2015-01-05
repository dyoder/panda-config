assert = require "assert"
{call} = require "when/generator"
Configurator = require "../src/index.coffee"

call ->

  try

    configurator = Configurator.make
      paths: [ "./imginary-bad-path" ]
      extension: ".json"

    configuration = configurator.make name: "settings"
    yield configuration.load()

    assert.false configuration
    data = configuration.data
    assert.false data

  catch error
    assert.ok error
