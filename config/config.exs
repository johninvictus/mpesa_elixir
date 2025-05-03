# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
import Config

config :mpesa_elixir,
  auth_req_options: [
    plug: {Req.Test, MpesaElixir.API}
  ],
  env: Mix.env()

# config :mpesa_elixir,
#   api_url: "https://sandbox.safaricom.co.ke",
#   consumer_key: "",
#   consumer_secret: "",
#   pass_key: "",
#   confirmation_url: "https://f8e607d1.ngrok.io/mpesa/callbacks/confirmation",
#   validation_url: "https://f8e607d1.ngrok.io/mpesa/callbacks/validation",
#   short_code: "",
#   b2c_initiator_name: "",
#   b2c_short_code: "",
#   response_type: "Cancelled",
#   certificate_path: "./lib/mpesa_elixir/keys/sandbox_cert.cer",
#   initiator_name: "apiop39",
#   b2c_queue_time_out_url: "https://f8e607d1.ngrok.io/mpesa/callbacks/validation",
#   b2c_result_url: "https://f8e607d1.ngrok.io/mpesa/callbacks/validation",
#   b2b_queue_time_out_url: "",
#   b2b_result_url: "",
#   balance_queue_time_out_url: "",
#   balance_result_url: "",
#   status_queue_time_out_url: "",
#   status_result_url: "",
#   reversal_queue_time_out_url: "",
#   reversal_result_url: "",
#   stk_call_back_url: "https://f8e607d1.ngrok.io/mpesa/callbacks/validation"

if File.exists?("config/config.secret.exs") do
  import_config("config.secret.exs")
end
