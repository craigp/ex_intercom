defmodule Intercom.Segment do

  @moduledoc """
  An Intercom segment.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Intercom.{HTTP, Request}
  alias __MODULE__

  @path "/segments"

  @primary_key false
  embedded_schema do
    field :name, :string
    field :id, :string
    field :type, :string
    field :created_at, :integer
    field :updated_at, :integer
    field :person_type, :string
    field :count, :integer
  end

  @type t :: %__MODULE__{}
  @type result :: {:ok, Segment.t} | {:error, any}

  @doc """
  Fetches a segment by its Intercom ID.
  """
  @spec get(String.t) :: result
  def get(id) when is_binary(id) do
    "#{@path}/#{id}"
    |> Request.build
    |> HTTP.get
    |> case do
      {:ok, map}             -> parse(map)
      {:error, {:http, 404}} -> {:error, :not_found}
      {:error, {:http, 401}} -> {:error, :not_authorised}
      {:error, _} = err      -> err
    end
  end

  @doc false
  @spec changeset(Segment.t, map) :: Ecto.Changeset.t
  def changeset(%Segment{} = segment, %{} = changes) do
    cast(segment, changes, __schema__(:fields))
  end

  @doc false
  @spec parse(map) :: result
  def parse(%{} = segment) do
    case changeset(%Segment{}, segment) do
      %Ecto.Changeset{valid?: true} = changes ->
        {:ok, apply_changes(changes)}
      %Ecto.Changeset{valid?: false} = changes ->
        {:error, changes}
    end
  end

end
