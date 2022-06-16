defmodule Apps do
  @moduledoc """
  Documentation for `Apps`.
  """


  def start do
    "geomer198"
    |> GitHub.Service.users_repo
    |> IO.inspect
  end
end
