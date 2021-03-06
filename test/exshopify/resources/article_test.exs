defmodule ExShopifyTest.Article do
  use ExUnit.Case, async: true

  setup do
    bypass  = Bypass.open
    session = ExShopify.Session.new(%{port: bypass.port})

    {:ok, bypass: bypass, session: session}
  end

  describe "authors" do
    test "decoder", %{bypass: bypass, session: session} do
      Bypass.expect(bypass, fn(conn) ->
        Plug.Conn.resp(conn, 200, "{\"authors\": [\"dennis\",\"John\",\"Rob\",\"Dennis\"]}")
      end)

      {:ok, authors, _} = ExShopify.Article.authors(session)

      assert authors == ["dennis", "John", "Rob", "Dennis"]
    end

    test "endpoint", %{bypass: bypass, session: session} do
      Bypass.expect(bypass, fn(conn) ->
        assert conn.method == "GET"
        assert conn.request_path == "/admin/articles/authors.json"

        Plug.Conn.resp(conn, 200, "{\"authors\": []}")
      end)

      ExShopify.Article.authors(session)
    end
  end

  describe "count" do
    test "endpoint", %{bypass: bypass, session: session} do
      Bypass.expect(bypass, fn(conn) ->
        assert conn.method == "GET"
        assert conn.request_path == "/admin/blogs/1/articles/count.json"

        Plug.Conn.resp(conn, 200, "{\"count\": 1}")
      end)

      ExShopify.Article.count(session, 1)
    end
  end

  describe "create" do
    test "endpoint", %{bypass: bypass, session: session} do
      Bypass.expect(bypass, fn(conn) ->
        conn = Plug.Parsers.call(conn, parsers: [Plug.Parsers.JSON], json_decoder: Poison)

        assert conn.method == "POST"
        assert conn.request_path == "/admin/blogs/1/articles.json"
        assert conn.params == %{"article" => %{}}

        Plug.Conn.resp(conn, 200, "{\"articles\": {}}")
      end)

      ExShopify.Article.create(session, 1, %{})
    end
  end

  describe "delete" do
    test "endpoint", %{bypass: bypass, session: session} do
      Bypass.expect(bypass, fn(conn) ->
        assert conn.method == "DELETE"
        assert conn.request_path == "/admin/blogs/2/articles/1.json"

        Plug.Conn.resp(conn, 200, "{}")
      end)

      ExShopify.Article.delete(session, 1, 2)
    end
  end

  describe "find" do
    test "endpoint", %{bypass: bypass, session: session} do
      Bypass.expect(bypass, fn(conn) ->
        assert conn.method == "GET"
        assert conn.request_path == "/admin/blogs/2/articles/1.json"

        Plug.Conn.resp(conn, 200, "{\"articles\": {}}")
      end)

      ExShopify.Article.find(session, 1, 2)
    end
  end

  describe "list" do
    test "endpoint", %{bypass: bypass, session: session} do
      Bypass.expect(bypass, fn(conn) ->
        assert conn.method == "GET"
        assert conn.request_path == "/admin/blogs/1/articles.json"

        Plug.Conn.resp(conn, 200, "{\"articles\": [{}]}")
      end)

      ExShopify.Article.list(session, 1)
    end
  end

  describe "tags" do
    test "decoder", %{bypass: bypass, session: session} do
      Bypass.expect(bypass, fn(conn) ->
        Plug.Conn.resp(conn, 200, "{\"tags\": [\"Announcing\",\"Mystery\"]}")
      end)

      {:ok, tags, _} = ExShopify.Article.tags(session)

      assert tags == ["Announcing", "Mystery"]
    end

    test "endpoint", %{bypass: bypass, session: session} do
      Bypass.expect(bypass, fn(conn) ->
        assert conn.method == "GET"
        assert conn.request_path == "/admin/articles/tags.json"

        Plug.Conn.resp(conn, 200, "{\"tags\": []}")
      end)

      ExShopify.Article.tags(session)
    end
  end

  describe "tags_from_blog" do
    test "endpoint", %{bypass: bypass, session: session} do
      Bypass.expect(bypass, fn(conn) ->
        assert conn.method == "GET"
        assert conn.request_path == "/admin/blogs/1/articles/tags.json"

        Plug.Conn.resp(conn, 200, "{\"tags\": []}")
      end)

      ExShopify.Article.tags_from_blog(session, 1)
    end
  end

  describe "update" do
    test "endpoint", %{bypass: bypass, session: session} do
      Bypass.expect(bypass, fn(conn) ->
        conn = Plug.Parsers.call(conn, parsers: [Plug.Parsers.JSON], json_decoder: Poison)

        assert conn.method == "PUT"
        assert conn.request_path == "/admin/blogs/2/articles/1.json"
        assert conn.params == %{"article" => %{}}

        Plug.Conn.resp(conn, 200, "{\"article\": {}}")
      end)

      ExShopify.Article.update(session, 1, 2, %{})
    end
  end
end
