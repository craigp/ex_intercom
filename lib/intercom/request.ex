defmodule ExIntercom.Request do

  @moduledoc false

  alias __MODULE__

  defstruct path: nil,
    query: nil,
    headers: [
      {"accept", "application/json"},
      {"authorization", "Bearer #{System.get_env("INTERCOM_ACCESS_TOKEN")}"}
    ]
  @type t :: %__MODULE__{}

  @spec build(String.t, map) :: Request.t
  def build(path, query \\ %{}) when is_binary(path) and is_map(query) do
    %Request{
      path: path,
      query: query
    }
  end

end
