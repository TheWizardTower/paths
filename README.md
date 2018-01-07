[![Build Status][travis-badge]][travis-link]
[![Slack Room][slack-badge]][slack-link]

# Paths

Create or append to environment variables.

## Install

With [fisherman]

```
fisher paths
```

This package needs a fish version greater than 2.2.0.

You also must install the envsubst binary. On fedora, this is in the gettext package.

```fish
dnf install envsubst
```

On other distros, ask your local package manager which package provides 'envsubst'.

## Usage

Create or overwrite environment variables.

```fish
echo VALUE > $paths_config/VAR.fish
```

Create or append to environment variables.

```fish
mkdir $paths_config/VAR
echo VALUE > $paths_config/VAR/KEY.fish
```

Prefix values to environment variables by having the file start with 'prefix'.

```fish
mkdir $paths_config/VAR
echo VALUE > $paths_config/VAR/PREFIX_KEY.fish
```

Define a separator for the values in the variable by writing to separator.fish

```fish
mkdir $paths_config/VAR
echo ':' > $paths_config/VAR/separator.fish
```

Variables will be expanded, using envsubst:

```fish
mkdir $paths_config/VAR
echo "$HOME/bin" > $paths_config/VAR/home_bin.fish
echo $VAR
... /home/username/bin ...
```

Where KEY is the name of the file that stores VAR's value and can be any name you wish.

When you're done, restart any open terminal sessions for the change to take effect.

### Examples

Set $EDITOR.

```fish
echo vim > $paths_config/EDITOR.fish
```

Append to $PATH.

```fish
mkdir $paths_config/PATH
echo $GOPATH/bin > $paths_config/PATH/GOBIN.fish
```

Append to $GOPATH, which uses ':' as a separator, like Bash does. Also expand
$HOME, so you don't have to change it for different usernames.

```fish
mkdir $paths_config/GOPATH
echo ':' > $paths_config/PATH/separator.fish
echo "$HOME/gobin" > $paths_config/GOPATH/home_bin.fish
```

[travis-link]: https://travis-ci.org/fisherman/paths
[travis-badge]: https://img.shields.io/travis/fisherman/paths.svg
[slack-link]: https://fisherman-wharf.herokuapp.com
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[fisherman]: https://github.com/fisherman/fisherman
