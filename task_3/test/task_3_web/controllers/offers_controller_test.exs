defmodule Task3Web.OffersControllerTest do

  use Task3Web.ConnCase

  test "getting nearest offers", %{conn: conn} do
    get(conn, "/jobs/offers/filter?lat=48.8659387&lon=2.34532&radius=1")
  end

end

