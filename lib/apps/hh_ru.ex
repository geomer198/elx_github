defmodule Apps.HhRu do
  use HTTPoison.Base

  def process_url(url) do
    "https://api.hh.ru/" <> url
  end

  def process_request_header(headers) do
    headers
  end

  def process_response_body(body) do
    body |> Poison.decode!
  end

end
