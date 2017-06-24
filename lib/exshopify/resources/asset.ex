defmodule ExShopify.Asset do
  @moduledoc """
  Individual files that make up a shop's theme.
  """

  import ExShopify.API
  import ExShopify.Resource

  @type asset_plural :: {:ok, [%ExShopify.Asset{}], %ExShopify.Meta{}}
  @type asset_singular :: {:ok, %ExShopify.Asset{}, %ExShopify.Meta{}}

  @plural "assets"
  @singular "asset"

  defstruct [:attachment, :content_type, :created_at, :key, :public_url, :size,
             :source_key, :src, :theme_id, :updated_at, :value]

  @spec create(%ExShopify.Session{}, integer | String.t, map) :: asset_singular | ExShopify.Resource.error
  defdelegate create(session, theme_id, params), to: __MODULE__, as: :update

  @doc """
  Remove theme assets from a shop.

  ## Examples

      iex> ExShopify.Asset.delete(session, 828155753, %{asset: %{key: "assets/bg-body.gif"}})
      {:ok, meta}
  """
  @spec delete(%ExShopify.Session{}, integer | String.t, map) :: ExShopify.Resource.only_meta | ExShopify.Resource.error
  def delete(session, theme_id, params) do
    request(:delete, "/themes/#{theme_id}/assets.json", params, session)
    |> decode(nil)
  end

  @doc """
  Find a specific asset within a theme.

  ## Examples

  ### Get a liquid template

      iex> ExShopify.Asset.find(session, 828155753, %{asset: %{key: "templates/index.liquid"}})
      {:ok, asset, meta}

  ### Get a theme image

      iex> ExShopify.Asset.find(session, 828155753, %{asset: %{key: "assets/bg-body.gif"}})
      {:ok, asset, meta}
  """
  @spec find(%ExShopify.Session{}, integer | String.t, map) :: asset_singular | ExShopify.Resource.error
  def find(session, theme_id, params) do
    request(:get, "/themes/#{theme_id}/assets.json", params, session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @doc """
  List of theme asset metadata.

  ## Examples

      iex> ExShopify.Asset.list(session, 828155753)
      {:ok, assets, meta}
  """
  @spec list(%ExShopify.Session{}, integer | String.t, map) :: asset_plural | ExShopify.Resource.error
  def list(session, theme_id, params) do
    request(:get, "/themes/#{theme_id}/assets.json", params, session)
    |> decode(decoder(@plural, [response_mapping()]))
  end

  @spec list(%ExShopify.Session{}, integer | String.t) :: asset_plural | ExShopify.Resource.error
  def list(session, theme_id) do
    list(session, theme_id, %{})
  end

  @doc """
  Create new assets and update existing ones.

  ## Examples

  ### Create a new image by providing a base64-encoded attachment

      iex> params = %ExShopify.Asset{
      ...>   key: "assets/empty.gif",
      ...>   attachment: Base.encode64(Fild.read("path/to/file.png"))
      ...> }

      iex> ExShopify.Asset.update(session, 828155753, params)
      {:ok, asset, meta}

  ### Update an image by providing a source URL from which to fetch the value

      iex> params = %ExShopify.Asset{
      ...>   key: "assets/empty.gif",
      ...>   src: "http://apple.com/new_bg.gif"
      ...> }

      iex> ExShopify.Asset.update(session, 828155753, params)
      {:ok, asset, meta}
  """
  @spec update(%ExShopify.Session{}, integer | String.t, map) :: asset_singular | ExShopify.Resource.error
  def update(session, theme_id, params) do
    request(:put, "/themes/#{theme_id}/assets.json", wrap_in_object(params, @singular), session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @doc false
  def response_mapping() do
    %__MODULE__{}
  end
end
