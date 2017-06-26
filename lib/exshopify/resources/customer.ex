defmodule ExShopify.Customer do
  @moduledoc """
  Information about the customer.
  """

  import ExShopify.API
  import ExShopify.Resource

  @type customer_account_activation_url :: {:ok, String.t, %ExShopify.Meta{}}
  @type customer_plural :: {:ok, [%ExShopify.Customer{}], %ExShopify.Meta{}}
  @type customer_singular :: {:ok, %ExShopify.Customer{}, %ExShopify.Meta{}}

  @plural "customers"
  @singular "customer"

  defstruct [:accepts_marketing, :addresses, :created_at, :default_address,
             :email, :first_name, :id, :last_name, :last_order_id,
             :last_order_name, :metafields, :multipass_identifier, :note,
             :orders_count, :state, :tags, :tax_exempt, :total_spent,
             :updated_at, :verified_email]

  @doc """
  Create account activation URL for an invited or disabled customer.

  ## Examples

      iex> ExShopify.Customer.account_activation_url(session, 207119551)
      {:ok, account_activation_url, meta}
  """
  @spec account_activation_url(%ExShopify.Session{}, integer | String.t) :: customer_account_activation_url | ExShopify.Resource.error
  def account_activation_url(session, id) do
    request(:post, "/customers/#{id}/account_activation_url.json", %{}, session)
    |> decode(&decode_account_activation_url/1)
  end

  @doc """
  Get a count of all customers.

  ## Examples

      iex> ExShopify.Customer.count(session)
      {:ok, count, meta}
  """
  @spec count(%ExShopify.Session{}, map) :: ExShopify.Resource.count | ExShopify.Resource.error
  def count(session, params) do
    request(:get, "/customers/count.json", params, session)
    |> decode(decoder("count"))
  end
  @spec count(%ExShopify.Session{}) :: ExShopify.Resource.count | ExShopify.Resource.error
  def count(session) do
    count(session, %{})
  end

  @doc """
  Create a new customer.

  ## Examples

  ### Create a new customer record

      iex> params = %{
      ...>   first_name: "Steve",
      ...>   last_name: "Lastnameson",
      ...>   email: "steve.lastnameson@example.com",
      ...>   verified_email: true,
      ...>   addresses: [
      ...>     %ExShopify.CustomerAddress{
      ...>       address1: "123 Oak St",
      ...>       city: "Ottawa",
      ...>       province: "ON",
      ...>       phone: "555-1212",
      ...>       zip: "123 ABC",
      ...>       first_name: "Mother",
      ...>       last_name: "Lastnameson",
      ...>       country: "CA"
      ...>     }
      ...>   ]
      ...> }

      iex> ExShopify.Customer.create(session ,params)
      {:ok, customer, meta}

  ### Create a new customer with password and password_confirmation and skip sending the welcome email

      iex> params = %{
      ...>   first_name: "Steve",
      ...>   last_name: "Lastnameson",
      ...>   email: "steve.lastnameson@example.com",
      ...>   verified_email: true,
      ...>   addresses: [
      ...>     %ExShopify.CustomerAddress{
      ...>       address1: "123 Oak St",
      ...>       city: "Ottawa",
      ...>       province: "ON",
      ...>       phone: "555-1212",
      ...>       zip: "123 ABC",
      ...>       first_name: "Mother",
      ...>       last_name: "Lastnameson",
      ...>       country: "CA"
      ...>     }
      ...>   ],
      ...>   password: "newpass",
      ...>   password_confirmation: "newpass",
      ...>   send_email_welcome: false
      ...> }

      iex> ExShopify.Customer.create(session ,params)
      {:ok, customer, meta}

  ### Create a new customer with send_email_invite

      iex> params = %{
      ...>   first_name: "Steve",
      ...>   last_name: "Lastnameson",
      ...>   email: "steve.lastnameson@example.com",
      ...>   verified_email: true,
      ...>   addresses: [
      ...>     %ExShopify.CustomerAddress{
      ...>       address1: "123 Oak St",
      ...>       city: "Ottawa",
      ...>       province: "ON",
      ...>       phone: "555-1212",
      ...>       zip: "123 ABC",
      ...>       first_name: "Mother",
      ...>       last_name: "Lastnameson",
      ...>       country: "CA"
      ...>     }
      ...>   ],
      ...>   send_email_invite: false
      ...> }

      iex> ExShopify.Customer.create(session ,params)
      {:ok, customer, meta}

  ### Create a new customer with a metafield

      iex> params = %{
      ...>   first_name: "Steve",
      ...>   last_name: "Lastnameson",
      ...>   email: "steve.lastnameson@example.com",
      ...>   verified_email: true,
      ...>   addresses: [
      ...>     %ExShopify.CustomerAddress{
      ...>       address1: "123 Oak St",
      ...>       city: "Ottawa",
      ...>       province: "ON",
      ...>       phone: "555-1212",
      ...>       zip: "123 ABC",
      ...>       first_name: "Mother",
      ...>       last_name: "Lastnameson",
      ...>       country: "CA"
      ...>     }
      ...>   ],
      ...>   metafields: [
      ...>     %ExShopify.Metafield{
      ...>       key: "key",
      ...>       value: "newvalue",
      ...>       value_type: "string",
      ...>       namespace: "global"
      ...>     }
      ...>   ]
      ...> }

      iex> ExShopify.Customer.create(session ,params)
      {:ok, customer, meta}
  """
  @spec create(%ExShopify.Session{}, map) :: customer_singular | ExShopify.Resource.error
  def create(session, params) do
    request(:post, "/customers.json", wrap_in_object(params, @singular), session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @doc """
  Delete a customer.

  ## Examples

      iex> ExShopify.Customer.delete(session, 207119551)
      {:ok, meta}
  """
  @spec delete(%ExShopify.Session{}, integer | String.t) :: ExShopify.Resource.only_meta | ExShopify.Resource.error
  def delete(session, id) do
    request(:delete, "/customers/#{id}.json", %{}, session)
    |> decode(nil)
  end

  @doc """
  Get a single customer by id.

  ## Examples

      iex> ExShopify.Customer.find(session, 207119551)
      {:ok, customer, meta}
  """
  @spec find(%ExShopify.Session{}, integer | String.t, map) :: customer_singular | ExShopify.Resource.error
  def find(session, id, params) do
    request(:get, "/customers/#{id}.json", params, session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @spec find(%ExShopify.Session{}, integer | String.t) :: customer_singular | ExShopify.Resource.error
  def find(session, id) do
    find(session, id, %{})
  end

  @doc """
  Retrieve all customers of a shop.

  ## Examples

  ### Get all customers for a shop

      iex> ExShopify.Customer.list(session)
      {:ok, customers, meta}

  ### Get a list of specific customers

      iex> ExShopify.Customer.list(session, %{ids: [207119551, 1073339468]})
      {:ok, customers, meta}
  """
  @spec list(%ExShopify.Session{}, map) :: customer_plural | ExShopify.Resource.error
  def list(session, params) do
    request(:get, "/customers.json", params, session)
    |> decode(decoder(@plural, [response_mapping()]))
  end

  @spec list(%ExShopify.Session{}) :: customer_plural | ExShopify.Resource.error
  def list(session) do
    list(session, %{})
  end

  @doc """
  Search for customers of a shop.

  ## Examples

      iex> ExShopify.Customer.search(session, "Bob country:United States")
  """
  @spec search(%ExShopify.Session{}, String.t) :: customer_plural | ExShopify.Resource.error
  def search(session, query) do
    request(:get, "/customers/search.json", %{query: query}, session)
    |> decode(decoder(@plural, [response_mapping()]))
  end

  @doc """
  Update a customer.

  ## Examples

      iex> ExShopify.Customer.update(session, 207119551, %{tags: "New Customer, Repeat Customer"})
      {:ok, customer, meta}
  """
  @spec update(%ExShopify.Session{}, integer | String.t, map) :: customer_singular | ExShopify.Resource.error
  def update(session, id, params) do
    request(:put, "/customers/#{id}.json", wrap_in_object(params, @singular), session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @doc false
  def response_mapping() do
    %ExShopify.Customer{
      addresses: [%ExShopify.CustomerAddress{}],
      default_address: %ExShopify.CustomerAddress{}
    }
  end

  # private

  defp decode_account_activation_url(body) do
    Poison.Parser.parse!(body)["account_activation_url"]
  end
end
