defmodule ExIntercom.Location do

  @moduledoc """
  An Intercom user location.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

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
    cast(location, changes, __schema__(:fields))
  end

end
