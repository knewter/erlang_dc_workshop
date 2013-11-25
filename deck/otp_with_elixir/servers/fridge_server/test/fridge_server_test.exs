defmodule FridgeServerTest do
  use ExUnit.Case

  setup do
    { :ok, fridge } = :gen_server.start_link FridgeServer.Server, [], []
    { :ok, [ server: fridge ] }
  end

  test "putting something into the fridge", meta do
    assert :ok == :gen_server.call(meta[:server], {:store, :bacon})
  end

  test "removing something from the fridge", meta do
    :gen_server.call(meta[:server], {:store, :bacon})
    assert {:ok, :bacon} == :gen_server.call(meta[:server], {:take, :bacon})
  end

  test "removing something from the fridge twice", meta do
    :gen_server.call(meta[:server], {:store, :bacon})
    assert {:ok, :bacon} == :gen_server.call(meta[:server], {:take, :bacon})
    assert :not_found == :gen_server.call(meta[:server], {:take, :bacon})
  end

  test "taking something from the fridge that isn't in there", meta do
    assert :not_found == :gen_server.call(meta[:server], {:take, :bacon})
  end
end
