defmodule Scaffolding.PageController do
  use Scaffolding.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
