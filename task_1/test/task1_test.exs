defmodule Task1Test do
  use ExUnit.Case
  doctest Task1

  test "jobs count per continent" do
    res = Task1.get_grouped_jobs()
    assert res["Asia"]["TOTAL"] == 43
  end
end
