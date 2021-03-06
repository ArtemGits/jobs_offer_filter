defmodule OffersSrv do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def find_nearest_jobs(point, radius) do
    GenServer.call(__MODULE__, {:nearest_jobs, point, radius})
  end

  def init(state) do
    #TODO adding more concurrency
    {:ok, Task3.set_grouped_jobs()}
  end

  def handle_call({:nearest_jobs, point, radius}, _from, state) do
    {:ok, groupped_jobs} = state
    jobs = Task3.find_nearest_jobs(groupped_jobs, radius, point)
    {:reply, jobs,  state}
  end
end
