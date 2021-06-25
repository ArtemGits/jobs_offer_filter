defmodule Task3Web.OffersControllerTest do

  use Task3Web.ConnCase


#TODO fix this tests, border region, entity match

  test "getting nearest offers", %{conn: conn} do
    res = get(conn, "/jobs/offers/filter?lat=48.8659387&lon=2.34532&radius=1")
    |> json_response(200)
    assert length(res) == 10
  end

  test "find jobs near saint-petersburg", %{conn: conn} do
    res =
    get(conn, "/jobs/offers/filter?lat=59.9311&lon=30.3609&radius=1")
    |> json_response(200)
    assert length(res) == 0
  end

end

