defmodule Intercom.Note do

  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Intercom.{User, Admin}
  alias __MODULE__

  @required_fields ~w(id)a
  @optional_fields ~w(type created_at body)a

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
    note
    |> cast(changes, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

end
