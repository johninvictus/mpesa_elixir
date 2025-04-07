# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
import Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :mpesa_elixir, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:mpesa_elixir, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

config :mpesa_elixir,
  api_url: "https://sandbox.safaricom.co.ke",
  consumer_key: "",
  consumer_secret: "",
  pass_key: "",
  confirmation_url: "https://f8e607d1.ngrok.io/mpesa/callbacks/confirmation",
  validation_url: "https://f8e607d1.ngrok.io/mpesa/callbacks/validation",
  short_code: "",
  b2c_initiator_name: "",
  b2c_short_code: "",
  response_type: "Cancelled",
  certificate_path: "./lib/mpesa_elixir/keys/sandbox_cert.cer",
  initiator_name: "apiop39",
  b2c_queue_time_out_url: "https://f8e607d1.ngrok.io/mpesa/callbacks/validation",
  b2c_result_url: "https://f8e607d1.ngrok.io/mpesa/callbacks/validation",
  b2b_queue_time_out_url: "",
  b2b_result_url: "",
  balance_queue_time_out_url: "",
  balance_result_url: "",
  status_queue_time_out_url: "",
  status_result_url: "",
  reversal_queue_time_out_url: "",
  reversal_result_url: "",
  stk_call_back_url: "https://f8e607d1.ngrok.io/mpesa/callbacks/validation"
