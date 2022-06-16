defmodule GitHub.Service do

  def find_user_by_login(login, page) do
    case GitHub.HTTP.get("/search/users?q=#{login}&per_page=10&page=#{page}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body
      {:ok, %HTTPoison.Response{status_code: 403}} -> %{"items" => []}
      {:error, _} -> %{"items" => []}
    end
    |> Map.get("items")
  end

  def users_repo(login) do
    IO.inspect login
    case GitHub.HTTP.get("/users/#{login}/repos") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body
      {:ok, %HTTPoison.Response{status_code: 403}} -> []
    end

  end

  def get_users_attr(user, key) do
    user
    |> Map.get(key)
  end

  def get_repo_attribute({:html_url, []}) do
    ["Не хватает запросов в секунду"]
  end

  def get_repo_attribute({:html_url, repos}) do
    repos
    |> Enum.map(fn item -> Map.get(item, "html_url") end)
  end

  def get_repo_attribute({:lang, []}) do
    ["Не хватает запросов в секунду"]
  end

  def get_repo_attribute({:lang, repos}) do
    repos
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
  end

  def get_users_info(login, page \\ 1) do
    find_user_by_login(login, page)
    |> Enum.map(
         fn user ->
           IO.inspect user
           user_login = get_users_attr(user, "login")
           repo = users_repo(user_login)
           IO.inspect user_login
           IO.inspect repo
           %{
             :avatar => get_users_attr(user, "avatar_url"),
             :id => get_users_attr(user, "id"),
             :url => get_users_attr(user, "html_url"),
             :login => get_users_attr(user, "login"),
             :links => get_repo_attribute({:html_url, repo}),
             :langs => get_repo_attribute({:lang, repo}),
           }
         end
       )
  end

end
