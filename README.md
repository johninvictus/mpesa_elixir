# MPESA ELIXIR

> ELixir Wrapper for Mpesa Daraja APIs
> https://developer.safaricom.co.ke/APIs

## Table of contents

- [Features](#features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Documentation](#documentation)
- [Contribution](#contribution)
- [Contributors](#contributors)
- [Licence](#licence)

## Features

- [x] STK Push
- [x] C2B
- [x] QRCode
- [x] Request universal MPESA API call

## Installation

If [available in Hex](https://hex.pm/packages/mpesa_elixir), the package can be installed
by adding `mpesa_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mpesa_elixir, "~> 0.2.1"}
  ]
end
```

## Configuration

Create a copy of `config/dev.exs` or `config/prod.exs` from `config/dev.sample.exs`
Use the `sandbox` key to `true` when you are using sandbox credentials, change to `false` when going to `:prod`, this will change the baseurl to point to production

### Mpesa (Daraja)

Mpesa Daraja API link: https://developer.safaricom.co.ke

Add below config to dev.exs / prod.exs files
This asumes you have a clear understanding of how [Daraja API works](https://developer.safaricom.co.ke/get-started).

In this wrapper I decided to only add credentials to config for flexibility and avoid config bloating.

```elixir
config :mpesa_elixir,
  sandbox: true, # change this if you are in production
  consumer_key: "your consumer key",
  consumer_secret: "your consumer secret",
  pass_key: "your pass key",
  env: Mix.env() # will not start the auth server when testing
```

## Documentation

The docs can be found at [https://hexdocs.pm/ex_mpesa](https://hexdocs.pm/mpesa_elixir)

## Contribution

If you'd like to contribute, start by searching through the [issues](https://github.com/johninvictus/mpesa_elixir/issues) and [pull requests](https://github.com/johninvictus/mpesa_elixir/pulls) to see whether someone else has raised a similar idea or question.
If you don't see your idea listed, [Open an issue](https://github.com/johninvictus/mpesa_elixir/issues).

Check the [Contribution guide](contributing.md) on how to contribute.

## Contributors

Auto-populated from:
[contributors-img](https://contributors-img.firebaseapp.com/image?repo=johninvictus/mpesa_elixir)

<a href="https://github.com/johninvictus/mpesa_elixir/graphs/contributors">
  <img src="https://contributors-img.firebaseapp.com/image?repo=johninvictus/mpesa_elixir" />
</a>

## Licence

MPESA ELIXIR is released under [MIT License](https://github.com/appcues/exsentry/blob/master/LICENSE.txt)

[![license](https://img.shields.io/github/license/mashape/apistatus.svg?style=for-the-badge)](#)
