# Panda Config

Panda Config helps you manage config files.

```coffee
Configuration = require "panda-config"
configuration = Configurator.create
  name: "settings"
  extension: "yml"
  format: "yaml"
options = yield Configuration.load configuration
assert options.messages.welcome == "Hello, World!"
```

Suppose you want a dot-file in your users' home directory:

```coffee
Configuration = require "panda-config"
configuration = Configuration.create
  name: "foo"
  prefix: "."
  paths: [ process.env.HOME ]
  format: "yaml"
options = yield load configuration
```

You can update configurations, too, making it easy to write command-line tools that update a configuration.

```
options.email = "johndoe@acme.org"
save configuration, options
```

## Status

This is an alpha release, meaning it is not recommended for production use.

## API

### Configuration

#### `create(options)`

Create a new configurator object. Valid options:

* `paths`: the list of paths to search when loading a configuration. Defaults to `["."]`.

* `prefix`: a prefix to use when generating the filename. Defaults to an empty string.

This is useful for creating application-specific prefixes when writing to a directory shared by other applications. It's also useful for create hidden dot-files.

* `extension`: a file-type extension, such as `.yaml`. Defaults to an empty string.

* `format`: the desired file-format. The two currently supported formats are `json` and `yaml`.

#### `load(configuration)`

Attempts to load and parse the configuration from a file.

#### `save(configuration)`

Attempts to save a configuration.
