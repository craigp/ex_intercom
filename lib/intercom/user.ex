defmodule Intercom.User do

  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Intercom.{Location, Avatar, Company, SocialProfile, Segment,
    Tag, Request, HTTP}
  alias __MODULE__

  @path "/users"
  @required_fields ~w(type id user_id)a
  @optional_fields ~w(email phone name updated_at last_seen_ip
    unsubscribed_from_emails last_request_at signed_up_at
    created_at session_count user_agent_data pseudonym anonymous)a

  @primary_key false
  embedded_schema do
    field :type, :string
    field :id, :string
    field :user_id, :string
    field :email, :string
    field :phone, :string
    field :name, :string
    field :updated_at, :integer
    field :last_seen_ip, :string
    field :unsubscribed_from_emails, :boolean
    field :last_request_at, :integer
    field :signed_up_at, :integer
    field :created_at, :integer
    field :session_count, :integer
    field :user_agent_data, :string
    field :pseudonym, :string
    field :anonymous, :boolean
    embeds_one :location, Location
    embeds_one :avatar, Avatar
    embeds_many :companies, Company
    embeds_many :social_profiles, SocialProfile
    embeds_many :segments, Segment
    embeds_many :tags, Tag
  end

  @type t :: %__MODULE__{}
  @typep result :: {:ok, User.t} | {:error, any}

  @doc """
  Fetches a user by their Intercom ID.
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

  @doc """
  Lookup a user by their assigned user ID or email address.
  """
  @spec find({:user_id | :email, String.t}) :: result
  def find({:user_id, user_id}) when is_binary(user_id) do
    @path
    |> Request.build(%{user_id: user_id})
    |> HTTP.get
    |> case do
      {:ok, map}        -> parse(map)
      {:error, _} = err -> err
    end
  end

  def find({:email, email}) do
    @path
    |> Request.build(%{email: email})
    |> HTTP.get
    |> case do
      {:ok, map}        -> parse(map)
      {:error, _} = err -> err
    end
  end

  @doc false
  @spec changeset(User.t, map) :: Ecto.Changeset.t
  def changeset(%User{} = user, %{} = changes) do
    user
    |> cast(changes, @required_fields ++ @optional_fields)
    |> cast_embed(:location, with: &Location.changeset/2)
    |> cast_embed(:avatar, with: &Avatar.changeset/2)
    |> cast_embed(:social_profiles, with: &SocialProfile.changeset/2)
    |> cast_embed(:companies, with: &Company.changeset/2)
    |> cast_embed(:segments, with: &Segment.changeset/2)
    |> cast_embed(:tags, with: &Tag.changeset/2)
    |> validate_required(@required_fields)
  end

  @doc false
  @spec parse(map) :: result
  def parse(%{} = user) do
    {loc, user} = Map.pop(user, :location_data)
    {%{social_profiles: profs}, user} = Map.pop(user, :social_profiles)
    {%{companies: comps}, user} = Map.pop(user, :companies)
    {%{segments: segs}, user} = Map.pop(user, :segments)
    {%{tags: tags}, user} = Map.pop(user, :tags)
    user =
      user
      |> Map.put(:location, loc)
      |> Map.put(:social_profiles, profs)
      |> Map.put(:companies, comps)
      |> Map.put(:segments, segs)
      |> Map.put(:tags, tags)
    case changeset(%User{}, user) do
      %Ecto.Changeset{valid?: true} = changes ->
        {:ok, apply_changes(changes)}
      %Ecto.Changeset{valid?: false} = changes ->
        {:error, changes}
    end
  end

end
