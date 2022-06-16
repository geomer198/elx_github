defmodule GitHub.HTTP do
  @moduledoc false
  use HTTPoison.Base

  def process_url(url) do
    "https://api.github.com" <> url
  end

  def process_request_header(headers) do
    headers
  end

  def process_response_body(body) do
    body |> Poison.decode!
  end

end
