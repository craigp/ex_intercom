defmodule ExIntercom.Tag do

  @moduledoc """
  An Intercom tag.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  @primary_key false
  embedded_schema do
    field :name, :string
    field :id, :string
    field :type, :string
  end

  @type t :: %__MODULE__{}

  @doc false
  @spec changeset(Tag.t, map) :: Ecto.Changeset.t
  def changeset(%Tag{} = tag, %{} = changes) do
    cast(tag, changes, __schema__(:fields))
  end

end
