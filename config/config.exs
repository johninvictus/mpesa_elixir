# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
import Config

config :mpesa_elixir,
  auth_req_options: [
    plug: {Req.Test, MpesaElixir.API}
  ],
  env: config_env(),
  auto_start_auth_server: config_env() != :test

if File.exists?("config/config.secret.exs") do
  import_config("config.secret.exs")
end
