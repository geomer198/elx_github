defmodule GitHub.HTTP do
  @moduledoc false
  use HTTPoison.Base

  def process_url(url) do
    "https://api.github.com" <> url
  end

  def process_request_header(options) do
    #    basic_auth = {"geomer198", "password"}
    #    Keyword.update(
    #      options,
    #      :hackney,
    #      Keyword.new(basic_auth: basic_auth),
    #      &Keyword.put_new(&1, :basic_auth, basic_auth)
    #    )
    options
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end

end
