# MpesaElixir


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `mpesa_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mpesa_elixir, "~> 0.1.0"}
  ]
end
```

Ensure the application added to `mix.ex` so that it can be started with the application supervisor
```
def application do
  [applications: [:mpesa_elixir]]
end
```

After adding the above to `mix.exs` install the download the dependencies.
```
mix deps.get
iex -S mix
```

## Quickstart
Configure the application, you can add the production credentials to `prod.exs` and then sandbox credentials to `dev.exs`.

> library configuration

```
config :mpesa_elixir,
  api_url: "https://sandbox.safaricom.co.ke",
  consumer_key: "",
  consumer_secret: "",
  pass_key: "",
  confirmation_url: "",
  validation_url: "",
  short_code: "",
  b2c_initiator_name: "",
  b2c_short_code: "",
  response_type: "Cancelled",
  certificate_path: "./lib/mpesa_elixir/keys/sandbox_cert.cer",
  initiator_name: "apiop39",
  b2c_queue_time_out_url: "",
  b2c_result_url: "",
  b2b_queue_time_out_url: "",
  b2b_result_url: "",
  balance_queue_time_out_url: "",
  balance_result_url: "",
  status_queue_time_out_url: "",
  status_result_url: "",
  reversal_queue_time_out_url: "",
  reversal_result_url: "",
  stk_call_back_url: ""
```

For the `certificate_path` you can provide your own production certificate.


## Usage

#### C2B functionality

First you need to register your `confirmation_url` and `validation_url` urls.

```
iex> MpesaElixir.C2b.register_callbacks()
```

Now you can simulate the transaction for testing in case you are using sandbox
msisdn : should be of the following format 254 ...
amount : eg 200
unique_reference : This will be returned to the callback

```
iex> MpesaElixir.C2b.simulate(msisdn, amount, unique_reference)
```


#### B2C functionality
Learn about the needed parameters here.
https://developer.safaricom.co.ke/docs?shell#b2b-api

```
MpesaElixir.B2b.payment_request(command_id, amount, sender_identifier, partyb,reciever_identifier_type, remarks, account_reference)
```

#### STK push
For this you will need to use these functions.


> To request money via push stk
https://developer.safaricom.co.ke/docs?shell#lipa-na-m-pesa-online-payment

```
iex> MpesaElixir.StkPush.processrequest(phone_number, pass_key, amount,account_reference, transaction_desc)
```


> To Query for stk push
https://developer.safaricom.co.ke/docs?shell#lipa-na-m-pesa-online-query-request

```
iex> MpesaElixir.StkPush.query(checkout_requestId)
```

#### Reversal Transaction

>To reverse a transaction, use this function.
https://developer.safaricom.co.ke/docs?shell#reversal

```
iex> MpesaElixir.Transaction.reverse(transaction_id, amount, receiver_party, reciever_identifier_type, remarks, occasion \\ nil)
```

#### Transaction Status
>Transaction Status API checks the status of a B2B, B2C and C2B APIs transactions.
https://developer.safaricom.co.ke/docs?shell#transaction-status

```
iex> MpesaElixir.Transaction.status(transaction_id, identifier_type, remarks, occasion \\ nil)
```


To learn the response from the MPESA servers I suggest reading the documentation extensively. https://developer.safaricom.co.ke/docs


TODO: Add tools to simplify how to deal with callbacks
