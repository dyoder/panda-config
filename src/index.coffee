{liftAll} = require "when/node"

async = (require "when/generator").lift
{readFile, writeFile} = liftAll require "fs"
exists = do ->
  {lift} = require "when/callbacks"
  lift (require "fs").exists

{resolve, join} = require "path"
{merge} = require "fairmont"

class Configuration

  constructor: ({@paths, @prefix, @extension, @format, @name}) ->

  load: async ->
    {read} = Configurator.formats[@format]
    filename = "#{@prefix}#{@name}#{@extension}"
    for directory in @paths
      path = resolve join directory, filename
      if yield exists path
        @data = read (yield readFile path).toString()
        @path = path
        return @
    throw new Error "Unable to find configuration named #{@name}"

  save: ->
    {write} = Configurator.formats[@format]
    if @path? && @data?
      writeFile @path, write @data
    else
      throw new Error "Unable to save configuration: no path or data"

  prepare: (path) ->
    filename = "#{@prefix}#{@name}#{@extension}"
    if path?
      for directory in @paths
        _path = resolve join directory, filename
        if path == _path
          return
      throw new Error "Invalid path provided"
    else
      [directory] = @paths
      @path = resolve join directory, filename


class Configurator

  @formats:
    yaml:
      read: (string) ->
        (require "js-yaml").safeLoad string
      write: (object) ->
        (require "js-yaml").safeDump object

    json:
      read: (string) -> JSON.parse string
      write: (object) -> JSON.stringify object

  @defaults:
    paths: ["."]
    prefix: ""
    extension: ""
    format: "yaml"

  @make: (options) -> new Configurator options

  constructor: (options) ->
    {@paths, @prefix, @extension, @format} =
      merge Configurator.defaults, options

  make: ({name}) ->
    new Configuration {@paths, @prefix, @extension, @format, name}

module.exports = Configurator
