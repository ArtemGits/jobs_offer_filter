defmodule Task3Web.Router do
  use Task3Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/jobs/offers/", Task3Web do
    pipe_through :api
    get "/filter", OffersController, :show
  end
end
