defmodule ExShopifyTest.PriceRule do
  use ExUnit.Case, async: true

  setup do
    bypass  = Bypass.open
    session = ExShopify.Session.new(%{port: bypass.port})

    {:ok, bypass: bypass, session: session}
  end

  describe "create" do
    test "endpoint", %{bypass: bypass, session: session} do
      Bypass.expect(bypass, fn(conn) ->
        conn = Plug.Parsers.call(conn, parsers: [Plug.Parsers.JSON], json_decoder: Poison)

        assert conn.method == "POST"
        assert conn.request_path == "/admin/price_rules.json"
        assert conn.params == %{"price_rule" => %{}}

        Plug.Conn.resp(conn, 200, "{\"price_rule\": {}}")
      end)

      ExShopify.PriceRule.create(session, %{})
    end
  end

  describe "delete" do
    test "endpoint", %{bypass: bypass, session: session} do
      Bypass.expect(bypass, fn(conn) ->
        assert conn.method == "DELETE"
        assert conn.request_path == "/admin/price_rules/1.json"

        Plug.Conn.resp(conn, 200, "{}")
      end)

      ExShopify.PriceRule.delete(session, 1)
    end
  end

  describe "disable" do
    test "endpoint", %{bypass: bypass, session: session} do
      Bypass.expect(bypass, fn(conn) ->
        assert conn.method == "POST"
        assert conn.request_path == "/admin/price_rules/1/disable.json"

        Plug.Conn.resp(conn, 200, "{}")
      end)

      ExShopify.PriceRule.disable(session, 1)
    end
  end

  describe "enable" do
    test "endpoint", %{bypass: bypass, session: session} do
      Bypass.expect(bypass, fn(conn) ->
        assert conn.method == "POST"
        assert conn.request_path == "/admin/price_rules/1/enable.json"

        Plug.Conn.resp(conn, 200, "{\"price_rule\": {}}")
      end)

      ExShopify.PriceRule.enable(session, 1)
    end
  end

  describe "find" do
    test "endpoint", %{bypass: bypass, session: session} do
      Bypass.expect(bypass, fn(conn) ->
        assert conn.method == "GET"
        assert conn.request_path == "/admin/price_rules/1.json"

        Plug.Conn.resp(conn, 200, "{\"price_rule\": {}}")
      end)

      ExShopify.PriceRule.find(session, 1)
    end
  end

  describe "list" do
    test "endpoint", %{bypass: bypass, session: session} do
      Bypass.expect(bypass, fn(conn) ->
        assert conn.method == "GET"
        assert conn.request_path == "/admin/price_rules.json"

        Plug.Conn.resp(conn, 200, "{\"price_rules\": [{}]}")
      end)

      ExShopify.PriceRule.list(session)
    end
  end
end

