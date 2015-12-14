{resolve, join} = require "path"
{liftAll} = require "when/node"
{read, write, exists, merge, async, Method} = require "fairmont"

defaults =
  paths: [ "." ]
  prefix: ""
  extension: ""
  format: "yaml"

create = (configuration) ->
  merge defaults, configuration

path = async ({paths, prefix, extension, format, name}) ->
  basename = "#{prefix}#{name}#{extension}"
  for directory in paths
    fullPath = resolve directory, basename
    if yield exists fullPath
      return fullPath
  # TODO: possibly just return a default path and mkdirp it?
  throw new Error "Unable to find configuration file [#{basename}]."

load = Method.create()

save = Method.create()

# YAML Format

isYAML = ({format}) -> format == "yaml"

Method.define load, isYAML, async (configuration) ->
  YAML = require "js-yaml"
  (YAML.safeLoad (yield read (yield path configuration)))

Method.define save, isYAML, (-> true), async (configuration, data) ->
  YAML = require "js-yaml"
  (yield write (yield path configuration), YAML.safeDump data)

# JSON Format

isJSON = ({format}) -> format == "json"

Method.define load, isJSON, async (configuration) ->
  YAML = require "js-yaml"
  (JSON.parse (yield read (yield path configuration)))

Method.define save, isJSON, (-> true), async (configuration, data) ->
  (yield write (yield path configuration), (JSON.stringify data, null, 2))

module.exports = {create, save, load}
