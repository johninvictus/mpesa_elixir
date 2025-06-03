defmodule MpesaElixir.AuthServer do
  @moduledoc """
  A GenServer implementation that manages Mpesa API authentication tokens.

  This server is responsible for:

  1. Obtaining an access token from the Mpesa API during initialization
  2. Storing the token in an ETS table for quick access
  3. Automatically refreshing the token before it expires
  4. Providing a function to retrieve the current token

  ## Usage

  The AuthServer should be added to your application's supervision tree:

  ```elixir
  children = [
    # ... other children
    MpesaElixir.AuthServer
  ]

  Supervisor.start_link(children, strategy: :one_for_one)
  ```

  You can then retrieve the current access token when needed:

  ```elixir
  token = MpesaElixir.AuthServer.get_token()
  ```

  ## Configuration

  The server requires the following configuration parameters:

  ```elixir
  config :mpesa_elixir,
    consumer_key: "your_consumer_key",
    consumer_secret: "your_consumer_secret"
  ```

  ## Implementation details

  - Uses ETS for token storage, with a named table `:token_store`
  - Automatically refreshes tokens 100 seconds before expiration
  - Gracefully shuts down if token retrieval fails
  """
  use GenServer

  alias MpesaElixir.API

  require Logger

  @token_store :token_store

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_token do
    case :ets.lookup(@token_store, :access_token) do
      [{:access_token, token}] ->
        token

      [] ->
        ""
    end
  end

  @impl true
  def init(_) do
    store = :ets.new(@token_store, [:set, :protected, :named_table])
    {:ok, store, {:continue, :fetch_token}}
  end

  @impl true
  def handle_continue(:fetch_token, state) do
    auth_options = [
      auth:
        {:basic,
         "#{Application.get_env(:mpesa_elixir, :consumer_key, "")}:#{Application.get_env(:mpesa_elixir, :consumer_secret, "")}"}
    ]

    options =
      if Application.get_env(:mpesa_elixir, :env) == :test,
        do:
          Keyword.merge(
            Application.get_env(:mpesa_elixir, :auth_req_options, []),
            auth_options
          ),
        else: auth_options

    result =
      API.request(
        "/oauth/v1/generate?grant_type=client_credentials",
        options
      )

    case result do
      {:ok, %{status: status, body: body}} when status == 200 ->
        access_token = body["access_token"]
        expires_in = String.to_integer(body["expires_in"])

        Process.send_after(self(), :refresh_token, :timer.seconds(expires_in) - 900)

        true = :ets.insert(state, {:access_token, access_token})

        {:noreply, state}

      resp ->
        Logger.error("Error fetching token: #{inspect(resp)}")
        # Gracefully shut down instead of crashing
        {:stop, :error, state}
    end
  end

  @impl true
  def handle_info(:refresh_token, state) do
    {:noreply, state, {:continue, :fetch_token}}
  end
end
