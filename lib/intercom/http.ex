defmodule ExIntercom.HTTP do

  @moduledoc false

  alias ExIntercom.Request

  @default_api_url "https://api.intercom.io"

  @doc false
  @spec get(Request.t) :: {:ok, map} | {:error, any}
  def get(%Request{path: path, query: %{} = query, headers: headers})
  when is_list(headers) do
    case HTTPoison.get(build_url(path, query), headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode(body, keys: :atoms)
      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, {:http, code}}
      {:error, _} = err ->
        err
    end
  end

  @spec build_url(String.t, map) :: String.t
  defp build_url("/" <> _ = path, %{} = query) do
    url = Application.get_env(:ex_intercom, :api_url, @default_api_url)
    "#{url}#{path}?#{URI.encode_query(query)}"
  end

end
