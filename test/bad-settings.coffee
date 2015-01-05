assert = require "assert"
{call} = require "when/generator"
Configurator = require "../src/index.coffee"

call ->

  # json
  try
    configurator = Configurator.make
      paths: [ "./test/config" ]
      extension: ".json"

    configuration = configurator.make name: "bad-settings"
    yield configuration.load()

    assert.fail configuration, null, "file configuration should not exist"
    data = configuration.data
    assert.fail data, undefined, "data should not exist"

  catch error
    console.log error
    assert.ok error
    assert.equal error.name, "JSONException"
    assert.equal error.reason, "missed comma between flow collection entries"

  # yaml
  try
    configurator = Configurator.make
      paths: [ "./test/config" ]
      extension: ".yaml"

    configuration = configurator.make name: "bad-settings"
    yield configuration.load()

    assert.fail configuration, null, "file configuration should not exist"
    data = configuration.data
    assert.fail data, undefined, "data should not exist"

  catch error
    assert.ok error.name, "YAMLException"
    assert.ok error.reason, "can not read a block mapping entry; a multiline key may not b ean implicit key"
    assert.ok error
