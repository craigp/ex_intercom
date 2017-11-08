defmodule Intercom.Avatar do

  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  @required_fields ~w(type)a
  @optional_fields ~w(image_url)a

  embedded_schema do
    field :type, :string
    field :image_url, :string
  end

  @type t :: %__MODULE__{}

  @doc false
  @spec changeset(Avatar.t, map) :: Ecto.Changeset.t
  def changeset(%Avatar{} = location, %{} = changes) do
    location
    |> cast(changes, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

end
