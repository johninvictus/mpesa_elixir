defmodule MpesaElixir.PublicKey do
  @moduledoc """
  This module will work with public key reading and extraction
  """
  require MpesaElixir.PublicKey.Record

  alias MpesaElixir.PublicKey.Record

  @doc """
  Extract public key from the certicate file

  iex > MpesaElixir.PublicKey.extract_public_from(path)

  ```
  {:RSAPublicKey, 2129828641 ..}
  ```
  """
  @spec extract_public_from(String.t()) :: {atom(), integer()}
  def extract_public_from(certfile) do
    cert_text =
      File.read!(certfile)
      |> String.trim()

    [pem_entry] = :public_key.pem_decode(cert_text)
    cert_decoded = :public_key.pem_entry_decode(pem_entry)

    plk_der =
      cert_decoded
      |> Record."Certificate"(:tbsCertificate)
      |> Record."TBSCertificate"(:subjectPublicKeyInfo)
      |> Record."SubjectPublicKeyInfo"(:subjectPublicKey)

    :public_key.der_decode(:RSAPublicKey, plk_der)
  end

  @doc """
  Take a public certificate ecypt it and then encode the cypher string to base64

  iex > MpesaElixir.PublicKey(public_key, "test")

  ```
  fdffdf ...
  ```
  """
  @spec generate_base64_cypherstring(term(), String.t()) :: String.t()
  def generate_base64_cypherstring(public_key, plain_text) do
    plain_text
    |> :public_key.encrypt_public(public_key, [{:rsa_pad, :rsa_pkcs1_padding}])
    |> :base64.encode()
  end
end
