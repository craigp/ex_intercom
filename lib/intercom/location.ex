defmodule Intercom.Location do

  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  @required_fields ~w(type)a
  @optional_fields ~w(city_name continent_code country_name
    country_code latitude longitude postal_code region_name
    timezone)a

  @primary_key false
  embedded_schema do
    field :type, :string
    field :city_name, :string
    field :continent_code, :string
    field :country_code, :string
    field :country_name, :string
    field :latitude, :float
    field :longitude, :float
    field :postal_code, :string
    field :region_name, :string
    field :timezone, :string
  end

  @type t :: %__MODULE__{}

  @doc false
  @spec changeset(Location.t, map) :: Ecto.Changeset.t
  def changeset(%Location{} = location, %{} = changes) do
    location
    |> cast(changes, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

end
