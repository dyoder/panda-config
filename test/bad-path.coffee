assert = require "assert"
{call} = require "when/generator"
Configurator = require "../src/index.coffee"

call ->

  # json
  try
    configurator = Configurator.make
      paths: [ "./imaginary-bad-path" ]
      extension: ".json"

    configuration = configurator.make name: "settings"
    yield configuration.load()

    assert.fail configuration, null, "file configuration should not exist"
    data = configuration.data
    assert.fail data, undefined, "data should not exist"

  catch error
    assert.ok error

  # yaml
  try
    configurator = Configurator.make
      paths: [ "./imaginary-bad-path" ]
      extension: ".yaml"

    configuration = configurator.make name: "settings"
    yield configuration.load()

    assert.fail configuration, null, "file configuration should not exist"
    data = configuration.data
    assert.fail data, undefined, "data should not exist"

  catch error
    assert.ok error

  # bad extension
  try
    configurator = Configurator.make
      paths: [ "./test/config" ]
      extension: ".excel"

    configuration = configurator.make name: "settings"
    yield configuration.load()

    assert.fail configuration, null, "file configuration should not exist"
    data = configuration.data
    assert.fail data, undefined, "data should not exist"

  catch error
    assert.ok error

