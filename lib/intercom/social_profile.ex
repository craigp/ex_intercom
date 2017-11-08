defmodule Intercom.SocialProfile do

  @moduledoc """
  An Intercom user social profile.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  @primary_key false
  embedded_schema do
    field :name, :string
    field :id, :string
    field :username, :string
    field :url, :string
  end

  @type t :: %__MODULE__{}

  @doc false
  @spec changeset(SocialProfile.t, map) :: Ecto.Changeset.t
  def changeset(%SocialProfile{} = social_profile, %{} = changes) do
    cast(social_profile, changes, __schema__(:fields))
  end

end
