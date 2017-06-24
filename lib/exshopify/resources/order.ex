defmodule ExShopify.Order do
  @moduledoc """
  An order is a customer's completed request to purchase one or more products
  from a shop. An order is created when a customer completes the checkout
  process, during which time s/he provides an email address, billing address and
  payment information.
  """

  import ExShopify.API
  import ExShopify.Resource

  @type order_plural :: {:ok, [%ExShopify.Order{}], %ExShopify.Meta{}}
  @type order_singular :: {:ok, %ExShopify.Order{}, %ExShopify.Meta{}}

  @plural "orders"
  @singular "order"

  defstruct [:billing_address, :browser_ip, :buyer_accepts_marketing,
             :cancel_reason, :cancelled_at, :cart_token, :client_details,
             :closed_at, :created_at, :currency, :customer, :discount_codes,
             :email, :financial_status, :fulfillments, :fulfillment_status,
             :tags, :id, :landing_site, :line_items, :location_id, :name,
             :note, :note_attributes, :number, :order_number,
             :payment_gateway_names, :processed_at, :processing_method,
             :referring_site, :refunds, :shipping_address, :shipping_lines,
             :source_name, :subtotal_price, :tax_lines, :taxes_included, :token,
             :total_discounts, :total_line_items_price, :total_price,
             :total_tax, :total_weight, :updated_at, :user_id,
             :order_status_url]

  @doc """
  Cancel an order.

  ## Examples

  ### Canceling an order

      iex> ExShopify.Order.cancel(session, 450789469)
      {:ok, order, meta}

  ### Canceling and refunding an order using the refund parameter

      iex> params = %{
      ...>   refund: %{
      ...>     restock: true,
      ...>     note: "Broke in shipping",
      ...>     shipping: %{
      ...>       full_refund: true
      ...>     },
      ...>     refund_line_items: [
      ...>       %{line_item_id: 466157049, quantity: 1}
      ...>     ],
      ...>     transactions: [
      ...>       %{
      ...>          parent_id: 1068278472,
      ...>          amount: "10.00",
      ...>          kind: "refund",
      ...>          gateway: "bogus"
      ...>        },
      ...>       %{
      ...>          parent_id: 1068278473,
      ...>          amount: "100.00",
      ...>          kind: "refund",
      ...>          gateway: "bogus"
      ...>        }
      ...>     ]
      ...>   }
      ...> }

      iex> ExShopify.Order.cancel(session, 450789469, params)
      {:ok, order, meta}
  """
  @spec cancel(%ExShopify.Session{}, integer | String.t, map) :: order_singular | ExShopify.Resource.error
  def cancel(session, id, params) do
    request(:post, "/orders/#{id}/cancel.json", params, session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @spec cancel(%ExShopify.Session{}, integer | String.t) :: order_singular | ExShopify.Resource.error
  def cancel(session, id) do
    cancel(session, id, %{})
  end

  @doc """
  Retrieve a count of all the orders.

  ## Examples

      iex> ExShopify.Order.count(session)
      {:ok, order, meta}
  """
  @spec count(%ExShopify.Session{}, map) :: ExShopify.Resource.count | ExShopify.Resource.error
  def count(session, params) do
    request(:get, "/orders/count.json", params, session)
    |> decode(decoder("count"))
  end

  @spec count(%ExShopify.Session{}) :: ExShopify.Resource.count | ExShopify.Resource.error
  def count(session) do
    count(session, %{})
  end

  @doc """
  Close an order.

  ## Examples

      iex> ExShopify.Order.close(session, 450789469)
      {:ok, order, meta}
  """
  @spec close(%ExShopify.Session{}, integer | String.t) :: order_singular | ExShopify.Resource.error
  def close(session, id) do
    request(:post, "/orders/#{id}/close.json", %{}, session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @doc """
  Create a new order.

  ## Examples

  ### Create a simple order without sending order/fulfillment receipt

      iex> params = %ExShopify.Order {
      ...>   email: "foo@example.com",
      ...>   fulfillment_status: "fulfilled",
      ...>   line_items: [
      ...>     %{
      ...>       variant_id: 447654529,
      ...>       quantity: 1
      ...>     }
      ...>   ]
      ...> }

      iex> ExShopify.Order.create(session, params)
      {:ok, order, meta}

  ### Create a partially paid order with a new customer and addresses

      iex> params = %ExShopify.Order {
      ...>   line_items: [
      ...>     %{
      ...>       variant_id: 447654529,
      ...>       quantity: 1
      ...>     }
      ...>   ],
      ...>   customer: %{
      ...>     first_name: "Paul",
      ...>     last_name: "Norman",
      ...>     email: "paul.norman@example.com"
      ...>   },
      ...>   billing_address: %{
      ...>     first_name: "John",
      ...>     last_name: "Smith",
      ...>     address1: "123 Fake Street",
      ...>     phone: "777-777-7777",
      ...>     city: "Fakecity",
      ...>     province: "Ontario",
      ...>     country: "Canada",
      ...>     zip: "K2P 1L4"
      ...>   },
      ...>   email: "jane@example.com",
      ...>   transactions: [
      ...>     %{
      ...>       kind: "authorization",
      ...>       status: "success",
      ...>       amount: 50.0
      ...>     }
      ...>   ],
      ...>   financial_status: "partially_paid"
      ...> }

      iex> ExShopify.Order.create(session, params)
      {:ok, order, meta}
  """
  @spec create(%ExShopify.Session{}, map) :: order_singular | ExShopify.Resource.error
  def create(session, params) do
    request(:post, "/orders.json", wrap_in_object(params, @singular), session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @doc """
  Delete an order.

  ## Examples

      iex> ExShopify.Order.delete(session, 450789469)
      {:ok, meta}
  """
  @spec delete(%ExShopify.Session{}, integer | String.t) :: ExShopify.Resource.only_meta | ExShopify.Resource.error
  def delete(session, id) do
    request(:delete, "/orders/#{id}.json", %{}, session)
    |> decode(nil)
  end

  @doc """
  Retrieve a specific order.

      iex> ExShopify.Order.find(session, 450789469)
      {:ok, order, meta}
  """
  @spec find(%ExShopify.Session{}, integer | String.t, map) :: order_singular | ExShopify.Resource.error
  def find(session, id, params) do
    request(:get, "/orders/#{id}.json", params, session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @spec find(%ExShopify.Session{}, integer | String.t) :: order_singular | ExShopify.Resource.error
  def find(session, id) do
    find(session, id, %{})
  end

  @doc """
  Retrieve a list of orders.

  ## Examples

      iex> ExShopify.Order.list(session)
      {:ok, orders, meta}
  """
  @spec list(%ExShopify.Session{}, map) :: order_plural | ExShopify.Resource.error
  def list(session, params) do
    request(:get, "/orders.json", params, session)
    |> decode(decoder(@plural, [response_mapping()]))
  end

  @spec list(%ExShopify.Session{}) :: order_plural | ExShopify.Resource.error
  def list(session) do
    list(session, %{})
  end

  @doc """
  Re-open a closed order.

  ## Examples

      iex> ExShopify.Order.open(session, 450789469)
      {:ok, order, meta}
  """
  @spec open(%ExShopify.Session{}, integer | String.t) :: order_singular | ExShopify.Resource.error
  def open(session, id) do
    request(:post, "/orders/#{id}/open.json", %{}, session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @doc """
  Update an order.

  ## Examples

      iex> params = %{
      ...>   email: "a-different@email.com"
      ...> }

      iex> ExShopify.Order.update(session, params)
      {:ok, order, meta}
  """
  @spec update(%ExShopify.Session{}, integer | String.t, map) :: order_singular | ExShopify.Resource.error
  def update(session, id, params) do
    request(:put, "/orders/#{id}.json", wrap_in_object(params, @singular), session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @doc false
  def response_mapping() do
    %ExShopify.Order{
      billing_address: %ExShopify.Address{},
      client_details: %ExShopify.ClientDetails{},
      customer: %ExShopify.Customer{},
      discount_codes: [%ExShopify.DiscountCode{}],
      fulfillments: [ExShopify.OrderFulfillment.response_mapping()],
      line_items: [ExShopify.LineItem.response_mapping()],
      refunds: [ExShopify.Refund.response_mapping()],
      shipping_address: %ExShopify.Address{},
      shipping_lines: [ExShopify.ShippingLine.response_mapping()],
      tax_lines: [%ExShopify.TaxLine{}]
    }
  end
end
