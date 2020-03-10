# `emoji-picker`
[![Build Status](https://travis-ci.org/jmackie/emoji-picker.svg?branch=master)](https://travis-ci.org/jmackie/emoji-picker)

<p align="center">
  <img alt="gif of emoji picker working with gedit" src="promo-gedit.gif" width="43%" /> 
  <img alt="gif of emoji picker working with a git commit message" src="promo-terminal.gif" width="40%" />
</p>

[`dmenu`](https://tools.suckless.org/dmenu/)-like Gtk thing for quickly looking up emojis.

## Installation

```
cargo install
```

Or if you're using [Nix](https://nixos.org/):

```
nix-env -f . -i
```

In which case you might also want use my [`cachix`](https://jmackie.cachix.org) 👍

```
cachix use jmackie
```

## Usage

```
emoji-picker
```

On it's own this will simply print your selection to `stdout`. So you'll probably want to pipe the output to your clipboard. Something like:

```
emoji-picker | xclip -selection clipboard
```

Then make that command a key binding and you're away son 🔥
