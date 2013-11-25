defmodule FridgeServerNicerInterfaceTest do
  use ExUnit.Case

  setup do
    { :ok, fridge } = FridgeServer.Server.start_link
    { :ok, [ server: fridge ] }
  end

  test "putting something into the fridge", meta do
    assert :ok == FridgeServer.Server.store(meta[:server], :bacon)
  end

  test "removing something from the fridge", meta do
    FridgeServer.Server.store(meta[:server], :bacon)
    assert {:ok, :bacon} == FridgeServer.Server.take(meta[:server], :bacon)
  end

  test "removing something from the fridge twice", meta do
    FridgeServer.Server.store(meta[:server], :bacon)
    assert {:ok, :bacon} == FridgeServer.Server.take(meta[:server], :bacon)
    assert :not_found == FridgeServer.Server.take(meta[:server], :bacon)
  end

  test "taking something from the fridge that isn't in there", meta do
    assert :not_found == FridgeServer.Server.take(meta[:server], :bacon)
  end
end
