assert = require "assert"
{call} = require "when/generator"
Configurator = require "../src/index.coffee"

call ->

  # prefixing file with dot
  try
    configurator = Configurator.make
      prefix: "."
      paths: [ "./test/config" ]
    configuration = configurator.make name: "foo"
    yield configuration.load()
    {prefix, format, data} = configuration
    assert.equal prefix, '.'
    assert.equal format, "yaml"
    assert.equal data.foo.bar, "boofar"

  catch error
    assert.fail error, null, "prefix make failed"


  # no path provided, should error
  try
    configurator = Configurator.make
      extension: ".yaml"
      #paths: [ "./test/config" ]

    assert.fail configuration, null
    configuration = configurator.make name: "save-settings"

    yield configuration.load()

    assert.fail configuration

    configuration.data.foo.bar = "Goodbye"

    yield configuration.save()

    configuration.load()

    assert.equal configuration.data.foo.bar, "Goodbye"

    configuration.data.foo.bar = "Hello"
    configuration.save()

  catch error
    assert.ok error

  # no path provided, path set later, should succeed
  try
    configurator = Configurator.make
      extension: ".yaml"
      #paths: [ "./test/config" ]

    configuration.prepare "./test/config"
    configuration = configurator.make name: "save-settings"

    yield configuration.load()

    assert.equal configuration.data.foo.bar, "Hello"

    configuration.data.foo.bar = "Goodbye"

    yield configuration.save()

    configuration.load()

    assert.equal configuration.data.foo.bar, "Goodbye"

    configuration.data.foo.bar = "Hello"
    configuration.save()

  catch error
    assert.fail error, null, "prepare path for save failed"
