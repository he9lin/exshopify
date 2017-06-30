defmodule ExShopify.PriceRule do
  @moduledoc """
  Applicable price_rules that can be applied to the order.
  """

  import ExShopify.API
  import ExShopify.Resource

  @type price_rule_plural :: {:ok, [%ExShopify.PriceRule{}], %ExShopify.Meta{}}
  @type price_rule_singular :: {:ok, %ExShopify.PriceRule{}, %ExShopify.Meta{}}

  @plural "price_rules"
  @singular "price_rule"

  defstruct [:title, :target_type, :target_selection, :allocation_method,
             :value_type, :value, :once_per_customer, :customer_selection,
             :entitled_collection_ids, :starts_at, :id, :usage_limit]

  @doc """
  Create a price_rule.

  ## Examples

  ### Create a price_rule title "SUMMER" that gives the buyer 15% off

      iex> params = %ExShopify.PriceRule{
      ...>   value_type: "percentage",
      ...>   value: "15.0",
      ...>   title: "SUMMER"
      ...> }

      iex> ExShopify.PriceRule.create(session, params)
      {:ok, price_rule, meta}

  """
  @spec create(%ExShopify.Session{}, map) :: price_rule_singular | ExShopify.Resource.error
  def create(session, params) do
    request(:post, "/price_rules.json", wrap_in_object(params, @singular), session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @doc """
  Delete a price_rule.

      iex> ExShopify.PriceRule.delete(session, 680866)
      {:ok, meta}
  """
  @spec delete(%ExShopify.Session{}, integer | String.t) :: ExShopify.Resource.only_meta | ExShopify.Resource.error
  def delete(session, id) do
    request(:delete, "/price_rules/#{id}.json", %{}, session)
    |> decode(nil)
  end

  @doc """
  Update a price_rule.

  ## Examples

      iex> ExShopify.Customer.update(session, 207119551, %{once_per_customer: false})
      {:ok, price_rule, meta}
  """
  @spec update(%ExShopify.Session{}, integer | String.t, map) :: price_rule_singular | ExShopify.Resource.error
  def update(session, id, params) do
    request(:put, "/price_rules/#{id}.json", wrap_in_object(params, @singular), session)
    |> decode(decoder(@singular, response_mapping()))
  end


  @doc """
  Disable a price_rule.

  ## Examples

      iex> ExShopify.PriceRule.disable(session, 680866)
      {:ok, meta}
  """
  @spec disable(%ExShopify.Session{}, integer | String.t) :: ExShopify.Resource.only_meta | ExShopify.Resource.error
  def disable(session, id) do
    request(:post, "/price_rules/#{id}/disable.json", %{}, session)
    |> decode(nil)
  end

  @doc """
  Enable a price_rule.

  ## Examples

      iex> ExShopify.PriceRule.enable(session, 949676421)
      {:ok, price_rule, meta}
  """
  @spec enable(%ExShopify.Session{}, integer | String.t) :: price_rule_singular | ExShopify.Resource.error
  def enable(session, id) do
    request(:post, "/price_rules/#{id}/enable.json", %{}, session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @doc """
  Retrieve a price_rule.

  ## Examples

      iex> ExShopify.PriceRule.find(session, 680866)
      {:ok, price_rule, meta}
  """
  @spec find(%ExShopify.Session{}, integer | String.t) :: price_rule_singular | ExShopify.Resource.error
  def find(session, id) do
    request(:get, "/price_rules/#{id}.json", %{}, session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @doc """
  List all price_rules.

  ## Examples

      iex> ExShopify.PriceRule.list(session)
      {:ok, price_rules, meta}
  """
  @spec list(%ExShopify.Session{}, map) :: price_rule_plural | ExShopify.Resource.error
  def list(session, params) do
    request(:get, "/price_rules.json", params, session)
    |> decode(decoder(@plural, [response_mapping()]))
  end

  @spec list(%ExShopify.Session{}) :: price_rule_plural | ExShopify.Resource.error
  def list(session) do
    list(session, %{})
  end

  @doc false
  def response_mapping() do
    %__MODULE__{}
  end
end
