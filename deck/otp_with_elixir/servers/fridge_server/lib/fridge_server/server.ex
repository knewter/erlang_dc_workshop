defmodule FridgeServer.Server do
  use GenServer.Behaviour

  # Public API
  def start_link do
    :gen_server.start_link(__MODULE__, [], [])
  end

  def store(server, item) do
    :gen_server.call(server, {:store, item})
  end

  def take(server, item) do
    :gen_server.call(server, {:take, item})
  end

  # GenServer API
  def handle_call({:store, item}, _from, items) do
    {:reply, :ok, [item|items]}
  end
  def handle_call({:take, item}, _from, items) do
    case Enum.member?(items, item) do
      true  -> {:reply, {:ok, item}, List.delete(items, item)}
      false -> {:reply, :not_found, items}
    end
  end
end
