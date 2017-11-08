defmodule Intercom.Company do

  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Intercom.{HTTP, Request}
  alias __MODULE__

  @path "/companies"
  @required_fields ~w(id)a
  @optional_fields ~w(type name plan company_id remote_created_at created_at
    updated_at size website industry monthly_spend session_count user_count)a

  @primary_key false
  embedded_schema do
    field :type, :string
    field :id, :string
    field :name, :string
    field :plan, :string
    field :company_id, :string
    field :remote_created_at, :integer
    field :created_at, :integer
    field :updated_at, :integer
    field :size, :integer
    field :website, :string
    field :industry, :string
    field :monthly_spend, :float
    field :session_count, :integer
    field :user_count, :integer
  end

  @type t :: %__MODULE__{}
  @typep result :: {:ok, Company.t} | {:error, any}

  @doc """
  Fetches a company by its Intercom ID.
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
  @spec changeset(Company.t, map) :: Ecto.Changeset.t
  def changeset(%Company{} = location, %{} = changes) do
    location
    |> cast(changes, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  @doc false
  @spec parse(map) :: result
  def parse(%{} = company) do
    case changeset(%Company{}, company) do
      %Ecto.Changeset{valid?: true} = changes ->
        {:ok, apply_changes(changes)}
      %Ecto.Changeset{valid?: false} = changes ->
        {:error, changes}
    end
  end

end
