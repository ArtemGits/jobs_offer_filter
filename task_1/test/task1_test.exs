defmodule Task1Test do
  use ExUnit.Case
  doctest Task1

  test "jobs count per continent" do
    Task1.get_grouped_jobs()
    |> IO.inspect()
  end
end
