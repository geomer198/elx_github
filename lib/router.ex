defmodule Apps.Router do
  @moduledoc false
  use Plug.Router

  plug :match
  plug Plug.Parsers,
       parsers: [:json],
       pass: ["*/*"],
       json_decoder: Poison

  plug :dispatch

  def child_spec(_opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def start_link() do
    {:ok, _} = Plug.Adapters.Cowboy.http(MyApp.Router, [], port: 4000)
  end

  def get_user_info(%{"gh_name" => login}) do
    GitHub.Service.get_users_info(login)
  end

  def get_user_info(_) do
    []
  end

  get "/" do
    IO.inspect conn.params
    IO.inspect Map.has_key?(conn.params, "gh_name")
    users = get_user_info(conn.params)
    IO.inspect users
    page = EEx.eval_file("templates/index.html", users: users || [])
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, page)
    |> halt
  end

  match _ do
    conn
    |> send_resp(404, "Not Found!")
  end

end
