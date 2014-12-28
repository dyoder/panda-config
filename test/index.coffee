assert = require = "assert"
{call} = require "when/generator"
Configurator = require "../src/index.coffee"

call ->

  configurator = Configurator.make paths: [ "." ]

  configuration = yield configurator.load "settings.cson"

  assert.equals configuration.foo.bar, "hello"

  configuration.foo.bar = "goodbye"
  configurator.save configuration
