ExUnit.start()

# Define mocks for testing
Mox.defmock(MpesaElixir.APIMock, for: MpesaElixir.API.Behaviour)

# Configure the app to use mocks in test environment
Application.put_env(:mpesa_elixir, :api_module, MpesaElixir.APIMock)
