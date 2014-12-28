{liftAll} = require "when/node"
{exists, readFile, writeFile} = liftAll require "fs"
{parse} = require "c50n"
{resolve, join} = require "path"

class Configurator

  @make: (options) -> new @ options

  constructor: ({@paths=["."], @prefix="", @extension=""}) ->

  load: (name) ->
    filename = "#{@prefix}#{name}#{@extension}"
    for directory in @paths
      path = resolve join directory, filename
      if yield exists path
        return parse (yield read path).toString()
    throw new Error "Unable to find configuration named #{name}"

  save: ->
