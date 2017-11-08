defmodule Intercom.Tag do

  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  @required_fields ~w(id)a
  @optional_fields ~w(type name)a

  @primary_key false
  embedded_schema do
    field :name, :string
    field :id, :string
    field :type, :string
  end

  @type t :: %__MODULE__{}

  @doc false
  @spec changeset(Tag.t, map) :: Ecto.Changeset.t
  def changeset(%Tag{} = location, %{} = changes) do
    location
    |> cast(changes, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

end
