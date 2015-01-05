# Panda Config

Panda Config helps you manage config files.

```coffee
Configurator = require "panda-config"
configurator = Configurator.make extension: "yml"
configuration = configurator.make "settings"
yield configuration.load()
console.log configuration.data.messages.welcome
```

The two-step to create a configurator allows you to manage many different types of configurations from within the same process. The basic idea is to allow you to encapsulate various styles of storing configurations, exporting either a configurator or a configuration instance.

Suppose you want a dot-file in your users' home directory:

```coffee
Configurator = require "panda-config"
configurator = Configurator.make
  prefix: "."
  paths: [ process.env.HOME ]
configuration = configuration.make "foo"
yield configuration.load()
console.log configuration.data.messages.welcome
```

You can update configurations, too, making it easy to write command-line tools that update a configuration.

```
configuration.data.email = "johndoe@acme.org"
configuration.save()
```


## Status

This is an alpha release, meaning it is not recommended for production use.

## API

### Configurator

#### Class Methods

`make(options)`: Create a new configurator object. Valid options:

* `paths`: the list of paths to search when loading a configuration. Defaults to `["."]`.

* `prefix`: a prefix to use when generating the filename. Defaults to an empty string.

This is useful for creating application-specific prefixes when writing to a directory shared by other applications. It's also useful for create hidden dot-files.

* `extension`: a file-type extension, such as `.yaml`. Defaults to an empty string.

* `format`: the desired file-format. The two currently supported formats are `json` and `yaml`.

#### Instance Methods

`make(options)`: Creates a new configuration object based on the configurator. Valid options:

* `name`: the name of the configuration. This will be combined with the configurator options to construct a pathname.

### Configuration

#### Instance Methods

`load`: Attempts to load and parse the configuration from a file. The pathname for the file is based on the configurator and the name of the configuration.

`save`: Attempts to save a configuration. Throws an exception if the configuration either has no associated path (because it was never loaded) or no data (and thus nothing to save).

`prepare(path=null)`: Prepares a configuration for calling `save` by setting the path. An exception will be thrown if the path can't be validated against the configurator and name. If no path is provided, a default will be generated based on the configurator, using the first element in `paths`.


### Tests

Run any test file in tests/ with `coffee --nodejs --harmony path/to/file`
