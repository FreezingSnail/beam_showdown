defmodule Showdown.Core.Fight do
  use GenServer

  @impl true
  def init(_) do
    {:ok, :core@fight.new_random_fight(), }
  end

  @impl true
  def handle_call(:pop, _from, state) do
    [to_caller | new_state] = state
    {:reply, to_caller, new_state}
  end

  @impl true
  def handle_cast({:push, element}, state) do
    new_state = [element | state]
    {:noreply, new_state}
  end

end
