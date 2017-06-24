defmodule ExShopify.Article do
  @moduledoc """
  A single entry in a blog.
  """

  import ExShopify.API
  import ExShopify.Resource

  @type author_plural :: {:ok, [String.t], %ExShopify.Meta{}}
  @type article_plural :: {:ok, [%ExShopify.Article{}], %ExShopify.Meta{}}
  @type article_singular :: {:ok, %ExShopify.Article{}, %ExShopify.Meta{}}
  @type tag_plural :: {:ok, [String.t], %ExShopify.Meta{}}

  @plural "articles"
  @singular "article"

  defstruct [:author, :blog_id, :body_html, :created_at, :id, :handle, :image,
             :metafields, :published, :published_at, :summary_html, :tags,
             :template_suffix, :title, :updated_at, :user_id]

  @doc """
  Get a list of all the authors of articles.

  ## Examples

      iex> ExShopify.Article.authors(session)
      {:ok, authors, meta}
  """
  @spec authors(%ExShopify.Session{}) :: author_plural | ExShopify.Resource.error
  def authors(session) do
    request(:get, "/articles/authors.json", %{}, session)
    |> decode(decoder("authors"))
  end

  @doc """
  Get a count of all articles from a certain blog.

  ## Examples

      iex> ExShopify.Article.count(session, 241253187)
      {:ok, count, meta}
  """
  @spec count(%ExShopify.Session{}, integer | String.t, map) :: ExShopify.Resource.count | ExShopify.Resource.error
  def count(session, blog_id, params) do
    request(:get, "/blogs/#{blog_id}/articles/count.json", params, session)
    |> decode(decoder("count"))
  end

  @spec count(%ExShopify.Session{}, integer | String.t) :: ExShopify.Resource.count | ExShopify.Resource.error
  def count(session, blog_id) do
    count(session, blog_id, %{})
  end

  @doc """
  Create a new article for a blog.

  ## Examples

  ### Create a new article with an image which will be downloaded by Shopify

      iex> params = %ExShopify.Article{
      ...>   title: "My new Article title",
      ...>   author: "John Smith",
      ...>   tags: "This Post, Has Been Tagged",
      ...>   body_html: "<h1>I like articles</h1>\\n<p><strong>Yea</strong>, I like posting them through <span class="caps">REST</span>.</p>",
      ...>   published_at: "Thu Mar 24 15:45:47 UTC 2016",
      ...>   image: {
      ...>     src: "http://example.com/elixir_logo.gif"
      ...>   }
      ...> }

      iex> ExShopify.Article.create(session, 241253187, params)
      {:ok, article, meta}

  ### Create a new article with a base64 encoded image

      iex> params = %ExShopify.Article{
      ...>   title: "My new Article title",
      ...>   author: "John Smith",
      ...>   tags: "This Post, Has Been Tagged",
      ...>   body_html: "<h1>I like articles</h1>\\n<p><strong>Yea</strong>, I like posting them through <span class="caps">REST</span>.</p>",
      ...>   published_at: "Thu Mar 24 15:45:47 UTC 2016",
      ...>   image: {
      ...>     attachment: Base.encode64(File.read("path/to/image.png"))
      ...>   }
      ...> }

      iex> ExShopify.Article.create(session, 241253187, params)
      {:ok, article, meta}

  ### Create an article with a metafield

      iex> params = %ExShopify.Article{
      ...>   title: "My new Article title",
      ...>   author: "John Smith",
      ...>   tags: "This Post, Has Been Tagged",
      ...>   body_html: "<h1>I like articles</h1>\\n<p><strong>Yea</strong>, I like posting them through <span class="caps">REST</span>.</p>",
      ...>   published_at: "Thu Mar 24 15:45:47 UTC 2016",
      ...>   metafields: [
      ...>     %ExShopify.Metafield{
      ...>       key: "new",
      ...>       value: "newvalue",
      ...>       value_type: "string",
      ...>       namespace: "global"
      ...>     }
      ...>   ]
      ...> }

      iex> ExShopify.Article.create(session, 241253187, params)
      {:ok, article, meta}
  """
  @spec create(%ExShopify.Session{}, integer | String.t, map) :: article_singular | ExShopify.Resource.error
  def create(session, blog_id, params) do
    request(:post, "/blogs/#{blog_id}/articles.json", wrap_in_object(params, @singular), session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @doc """
  Delete an article of a blog.

  ## Examples

      iex> ExShopify.Article.delete(session, 134645308, 241253187)
      {:ok, meta}
  """
  @spec delete(%ExShopify.Session{}, integer | String.t, integer | String.t) :: ExShopify.Resource.only_meta | ExShopify.Resource.error
  def delete(session, id, blog_id) do
    request(:delete, "/blogs/#{blog_id}/articles/#{id}.json", %{}, session)
    |> decode(nil)
  end

  @doc """
  Get a single article by its id and the id of the parent blog.

  ## Examples

      iex> ExShopify.Article.find(session, 134645308, 241253187, %{})
      {:ok, article, meta}
  """
  @spec find(%ExShopify.Session{}, integer | String.t, integer | String.t, map) :: article_singular | ExShopify.Resource.error
  def find(session, id, blog_id, params) do
    request(:get, "/blogs/#{blog_id}/articles/#{id}.json", params, session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @spec find(%ExShopify.Session{}, integer | String.t, integer | String.t) :: article_singular | ExShopify.Resource.error
  def find(session, id, blog_id) do
    find(session, id, blog_id, %{})
  end

  @doc """
  Get a list of all articles from a certain blog.

  ## Examples

  ### Get all the articles

      iex> ExShopify.Article.list(session, 241253187, %{})
      {:ok, articles, meta}

  ### Get all the articles after the specified id

      iex> ExShopify.Article.list(session, 241253187, %{since_id: 134645308})
      {:ok, articles, meta}
  """
  @spec list(%ExShopify.Session{}, integer | String.t, map) :: article_plural | ExShopify.Resource.error
  def list(session, blog_id, params) do
    request(:get, "/blogs/#{blog_id}/articles.json", params, session)
    |> decode(decoder(@plural, [response_mapping()]))
  end

  @spec list(%ExShopify.Session{}, integer | String.t) :: article_plural | ExShopify.Resource.error
  def list(session, blog_id) do
    list(session, blog_id, %{})
  end

  @doc """
  Get a list of all the tags of articles.

  ## Examples

  ### Get a list of all tags of articles

      iex> ExShopify.Article.tags(session)
      {:ok, tags, meta}

  ### Get a list of the most popular tags

      iex> ExShopify.Article.tags(session, %{limit: 1, popular: 1})
      {:ok, tags, meta}

  ### Get a list of all tags from a specific blog

      iex> ExShopify.Article.tags(session, %{})
      {:ok, tags, meta}

  ### Get a list of the most popular tags

      iex> ExShopify.Article.tags(session, %{limit: 1, popular: 1})
      {:ok, tags, meta}
  """
  @spec tags(%ExShopify.Session{}, map) :: tag_plural
  def tags(session, params) do
    request(:get, "/articles/tags.json", params, session)
    |> decode(decoder("tags"))
  end

  @spec tags(%ExShopify.Session{}) :: tag_plural
  def tags(session) do
    tags(session, %{})
  end

  @doc """
  Get a list of all the tags of articles for a specific blog.

  ## Examples

  ### Get a list of all tags of articles

      iex> ExShopify.Article.tags_from_blog(session, 134645308)
      {:ok, tags, meta}

  ### Get a list of the most popular tags

      iex> ExShopify.Article.tags_from_blog(session, 134645308, %{limit: 1, popular: 1})
      {:ok, tags, meta}

  ### Get a list of the most popular tags

      iex> ExShopify.Article.tags(session, 134645308, %{limit: 1, popular: 1})
      {:ok, tags, meta}
  """
  @spec tags_from_blog(%ExShopify.Session{}, integer | String.t, map) :: tag_plural
  def tags_from_blog(session, blog_id, params) do
    request(:get, "/blogs/#{blog_id}/articles/tags.json", params, session)
    |> decode(decoder("tags"))
  end

  @spec tags_from_blog(%ExShopify.Session{}, integer | String.t) :: tag_plural
  def tags_from_blog(session, blog_id) do
    tags_from_blog(session, blog_id, %{})
  end

  @doc """
  Update an article.

  ## Examples

      iex> ExShopify.Article.update(session, 134645308, 241253187, %{published: false})
      {:ok, article, meta}
  """
  @spec update(%ExShopify.Session{}, integer | String.t, integer | String.t, map) :: article_singular | ExShopify.Resource.error
  def update(session, id, blog_id, params) do
    request(:put, "/blogs/#{blog_id}/articles/#{id}.json", wrap_in_object(params, @singular), session)
    |> decode(decoder(@singular, response_mapping()))
  end

  @doc false
  def response_mapping() do
    %ExShopify.Article{
      metafields: [%ExShopify.Metafield{}]
    }
  end
end
