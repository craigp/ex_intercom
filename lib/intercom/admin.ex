defmodule Intercom.Admin do

  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Intercom.{HTTP, Request}
  alias __MODULE__

  @path "/admins"
  @required_fields ~w(id)a
  @optional_fields ~w(type name email)a

  @primary_key false
  embedded_schema do
    field :type, :string
    field :id, :string
    field :name, :string
    field :email, :string
  end

  @type t :: %__MODULE__{}
  @typep result :: {:ok, Admin.t} | {:error, any}

  @doc """
  Fetches an admin by their Intercom ID.
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
  @spec changeset(Admin.t, map) :: Ecto.Changeset.t
  def changeset(%Admin{} = admin, %{} = changes) do
    admin
    |> cast(changes, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  @doc false
  @spec parse(map) :: result
  def parse(%{} = admin) do
    case changeset(%Admin{}, admin) do
      %Ecto.Changeset{valid?: true} = changes ->
        {:ok, apply_changes(changes)}
      %Ecto.Changeset{valid?: false} = changes ->
        {:error, changes}
    end
  end

end
