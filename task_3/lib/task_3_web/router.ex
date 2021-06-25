defmodule Task3Web.Router do
  use Task3Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Task3Web do
    pipe_through :api
  end
end
