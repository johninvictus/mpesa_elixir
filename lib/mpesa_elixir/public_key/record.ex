defmodule MpesaElixir.PublicKey.Record do
  require Record
  import Record, only: [defrecord: 2, extract: 2]

  @public_key "public_key/include/public_key.hrl"

  defrecord :Certificate, extract(:Certificate, from_lib: @public_key)
  defrecord :TBSCertificate, extract(:TBSCertificate, from_lib: @public_key)
  defrecord :SubjectPublicKeyInfo, extract(:SubjectPublicKeyInfo, from_lib: @public_key)
end
