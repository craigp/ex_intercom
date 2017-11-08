defmodule Intercom.Company do

  @moduledoc """
  An Intercom company.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Intercom.{HTTP, Request}
  alias __MODULE__

  @path "/companies"

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
  @type result :: {:ok, Company.t} | {:error, any}

  @doc """
  Fetches a company by its Intercom ID.
  """
  @spec get(String.t) :: result
  def get(id) when is_binary(id) do
    "#{@path}/#{id}"
    |> Request.build
    |> HTTP.get
    |> case do
      {:ok, map}             -> parse(map)
      {:error, {:http, 404}} -> {:error, :not_found}
      {:error, {:http, 401}} -> {:error, :not_authorised}
      {:error, _} = err      -> err
    end
  end

  @doc false
  @spec changeset(Company.t, map) :: Ecto.Changeset.t
  def changeset(%Company{} = company, %{} = changes) do
    cast(company, changes, __schema__(:fields))
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
