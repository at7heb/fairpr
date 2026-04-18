defmodule FairprWeb.PageController do
  use FairprWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
