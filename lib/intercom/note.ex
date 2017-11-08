defmodule Intercom.Note do

  @moduledoc """
  An Intercom user note.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Intercom.{User, Admin}
  alias __MODULE__

  @primary_key false
  embedded_schema do
    field :type, :string
    field :id, :string
    field :created_at, :integer
    field :body, :string
    embeds_one :user, User
    embeds_one :admin, Admin
  end

  @type t :: %__MODULE__{}

  @doc false
  @spec changeset(Note.t, map) :: Ecto.Changeset.t
  def changeset(%Note{} = note, %{} = changes) do
    cast(note, changes, __schema__(:fields) -- __schema__(:embeds))
  end

end
