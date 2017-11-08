defmodule Intercom.Segment do

  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Intercom.{HTTP, Request}
  alias __MODULE__

  @path "/segments"
  @required_fields ~w(id)a
  @optional_fields ~w(type name created_at updated_at person_type count)a

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
  @typep result :: {:ok, Segment.t} | {:error, any}

  @doc """
  Fetches a segment by its Intercom ID.
  """
  @spec get(String.t) :: result
  def get(id) when is_binary(id) do
    "#{@path}/#{id}"
    |> Request.build
    |> HTTP.get
    |> case do
      {:ok, map}        -> parse(map)
      {:error, _} = err -> err
    end
  end

  @doc false
  @spec changeset(Segment.t, map) :: Ecto.Changeset.t
  def changeset(%Segment{} = location, %{} = changes) do
    location
    |> cast(changes, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
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
