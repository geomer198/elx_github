defmodule GitHub.Service do

  def find_user_by_login(login) do
    user =
      case GitHub.HTTP.get("/users/#{login}") do
        {:ok, response} -> response.body
      end
  end

  def users_repo(user_login) do
    repos =
      case GitHub.HTTP.get("/users/#{user_login}/repos") do
        {:ok, response} -> response.body
      end
  end

  def get_users_attr(user, key) do
    user
    |> Map.get(key)
  end

  def get_links_repo(repos) do
    repos
    |> Enum.map(fn item -> Map.get(item, "html_url") end)
  end

  def get_lang_in_repo(repo) do
    repo
    |> Enum.map(fn repo -> Map.get(repo, "languages_url") end)
    |> Enum.map(
         fn lang_item ->
           case HTTPoison.get(lang_item) do
             {:ok, response} ->
               response.body
               |> Poison.decode!
           end
         end
       )
    |> Enum.map(fn obj -> Map.keys(obj) end)
    |> Enum.reduce(fn f, s -> f ++ s end)
    |> Enum.join("<br/>")
  end

  def get_users_info(login) do
    user = find_user_by_login(login)
    repo = users_repo(login)
    IO.inspect user
    [
      %{
        :id => get_users_attr(user, "id"),
        :login => get_users_attr(user, "login"),
        :links => get_links_repo(repo),
        :langs => get_lang_in_repo(repo),
      }
    ]
  end

end
