defmodule ExShopify.PriceRule.DiscountCode do
  @moduledoc """
  A shipment of one or more items in an order.
  """

  import ExShopify.API
  import ExShopify.Resource

  @type discount_code_plural :: {:ok, [%ExShopify.PriceRule.DiscountCode{}], %ExShopify.Meta{}}
  @type discount_code_singular :: {:ok, %ExShopify.PriceRule.DiscountCode{}, %ExShopify.Meta{}}

  @plural "discount_codes"
  @singular "discount_code"

  defstruct [:created_at, :id, :code, :price_rule_id, :usage_count, :updated_at]

  @doc """
  Create a new discount_code.

  ## Examples

      iex> params = %ExShopify.PriceRule.DiscountCode{
      ...>   code: "SUMMER"
      ...> }

      iex> ExShopify.PriceRule.DiscountCode.create(session, 450789469, params)
      {:ok, discount_code, meta}
  """
  @spec create(%ExShopify.Session{}, integer | String.t, map) :: discount_code_singular | ExShopify.Resource.error
  def create(session, price_rule_id, params) do
    request(:post, "/price_rules/#{price_rule_id}/discount_codes.json", wrap_in_object(params, @singular), session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @doc """
  Receive a single discount_code.

  ## Examples

      iex> ExShopify.PriceRule.DiscountCode.find(session, 255858046, 450789469)
      {:ok, discount_code, meta}
  """
  @spec find(%ExShopify.Session{}, integer | String.t, integer | String.t, map) :: discount_code_singular | ExShopify.Resource.error
  def find(session, id, price_rule_id, params) do
    request(:get, "/price_rules/#{price_rule_id}/discount_codes/#{id}.json", params, session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @spec find(%ExShopify.Session{}, integer | String.t, integer | String.t) :: discount_code_singular | ExShopify.Resource.error
  def find(session, id, price_rule_id) do
    find(session, id, price_rule_id, %{})
  end

  @doc """
  Receive a list of all discount_codes.

  ## Examples

  ### Get a list of all discount_codes for an order.

      iex> ExShopify.PriceRule.DiscountCode.list(session, 450789469)
      {:ok, discount_codes, meta}

  ### Get all discount_codes after the specified ID

      iex> params = %{
      ...>   since_id: 255858046
      ...> }

      iex> ExShopify.PriceRule.DiscountCode.list(session, 450789469, params)
      {:ok, discount_codes, meta}
  """
  @spec list(%ExShopify.Session{}, integer | String.t, map) :: discount_code_plural | ExShopify.Resource.error
  def list(session, price_rule_id, params) do
    request(:get, "/price_rules/#{price_rule_id}/discount_codes.json", params, session)
    |> decode(decoder(@plural, [response_mapping()]))
  end

  @spec list(%ExShopify.Session{}, integer | String.t) :: discount_code_plural | ExShopify.Resource.error
  def list(session, price_rule_id) do
    list(session, price_rule_id, %{})
  end

  @doc """
  Modify an existing discount_code.

  ## Examples

      iex> params = %{code: "NEW"}

      iex> ExShopify.PriceRule.DiscountCode.update(session, 255858046, 450789469, params)
      {:ok, discount_code, meta}
  """
  @spec update(%ExShopify.Session{}, integer | String.t, integer | String.t, map) :: discount_code_singular | ExShopify.Resource.error
  def update(session, id, price_rule_id, params) do
    request(:put, "/price_rules/#{price_rule_id}/discount_codes/#{id}.json", wrap_in_object(params, @singular), session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @doc false
  def response_mapping() do
    %__MODULE__{}
  end
end
