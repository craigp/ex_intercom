defmodule ExIntercom.Avatar do

  @moduledoc """
  An Intercom user avatar.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  embedded_schema do
    field :type, :string
    field :image_url, :string
  end

  @type t :: %__MODULE__{}

  @doc false
  @spec changeset(Avatar.t, map) :: Ecto.Changeset.t
  def changeset(%Avatar{} = avatar, %{} = changes) do
    cast(avatar, changes, __schema__(:fields))
  end

end
