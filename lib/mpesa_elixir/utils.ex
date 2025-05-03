defmodule MpesaElixir.Utils do
  @moduledoc """
  Utility functions for the MpesaElixir application.
  """

  @doc """
  Generates a timestamp in the format YYYYMMDDHHMMSS.
  The timestamp is generated based on the current UTC time, adjusted by 3 hours (Nairobi Timezone).
  """
  @spec generate_timestamp() :: String.t()
  def generate_timestamp do
    today = NaiveDateTime.add(NaiveDateTime.utc_now(), 3600 * 3)

    [today.year, today.month, today.day, today.hour, today.minute, today.second]
    |> Enum.map(&to_string/1)
    |> Enum.map_join(&String.pad_leading(&1, 2, "0"))
  end

  @doc """
  Generates the base64 encoded password string from shortcode, passkey and timestamp.

  ## Examples

      iex> MPesa.StkPush.Request.generate_password("174379", "bfb279f9aa9bdbcf158e97dd71a467cd2e0c89305", "20160216165627")
      "MTc0Mzc5YmZiMjc5ZjlhYTliZGJjZjE1OGU5N2RkNzFhNDY3Y2QyZTBjODkzMDU5YjEwZjc4ZTZiNzJhZGExZWQyYzkxOTIwMTYwMjE2MTY1NjI3"
  """
  def generate_password(shortcode, passkey, timestamp) do
    "#{shortcode}#{passkey}#{timestamp}"
    |> Base.encode64()
  end

  def capitalize(string, options) do
    special_cases = Keyword.get(options, :special_cases, [])

    string
    |> String.split()
    |> Enum.map_join(fn word ->
      if Enum.member?(special_cases, String.downcase(word)),
        do: String.upcase(word),
        else: String.capitalize(word)
    end)
  end
end
