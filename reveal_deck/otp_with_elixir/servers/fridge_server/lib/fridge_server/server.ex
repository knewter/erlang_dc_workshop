defmodule FridgeServer.Server do
  use GenServer.Behaviour

  # Public Interface
  def start_link do
    :gen_server.start_link __MODULE__, [], []
  end

  def store(server, item) do
    :gen_server.call(server, {:store, item})
  end

  def take(server, item) do
    :gen_server.call(server, {:take, item})
  end

  # GenServer API
  def handle_call({:store, thing}, _from, items) do
    {:reply, :ok, [thing|items]}
  end
  def handle_call({:take, thing}, _from, items) do
    case Enum.member?(items, thing) do
      true  -> {:reply, {:ok, thing}, List.delete(items, thing)}
      false -> {:reply, :not_found, items}
    end
  end
end
