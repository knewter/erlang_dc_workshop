# GenServer.Behaviour
Implementing a simple server to manage some state using GenServer.Behaviour.


## What is GenServer?
GenServer stands for "Generic Server", and is a standardized implementation of
the client/server model for sharing a resource.  Basically, it makes it pretty
painless to share and manage access to a bit of state from multiple different
processes, using message passing.


## Starting Project
I've provided a starting project to go alongside this slide deck, and it's all
available on github at https://github.com/knewter/erlang_dc_workshop

Anyway, it just has a test in it.  Let's look at that.


```elixir
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
```


## Using GenServer.Behaviour
So let's go ahead and start implementing the server this test is looking for.
We'll start out by generating a `lib/fridge_server/server.ex` file and putting a
module named `FridgeServer.Server` in there.


## Using GenServer.Behaviour
Next, we'll go ahead and `use GenServer.Behaviour`.  That in itself is enough to
start making our tests fail differently.  Now, they basically fail because the
server never handles the call messages it's sent.  Let's give it a basic
implementation of replying to those messages, so that the timeouts will stop:

```elixir
  def handle_call(_call, _from, state) do
    {:reply, :error, state}
  end
```


## Using GenServer.Behaviour
Running the tests now gives us instant feedback.  Let's implement the `:store`
call by making it add the second element of the call to the server's state.
We'll also rename 'state' to 'items' so that it's a bit more representative of
what we're dealing with.  We'll replace the earlier `handle_call` entirely.

```elixir
  def handle_call({:store, item}, _from, items) do
    {:reply, :ok, [item|items]}
  end
```


## Using GenServer.Behaviour
This time when we ran the tests, we saw a more legitimate looking failure -
basically, the call to `{:take, item}` wasn't matched by any `handle_call`
function clause, and so the server crashed.  Let's go ahead and implement that
call:

```elixir
  def handle_call({:take, item}, _from, items) do
    {:reply, {:ok, item}, items}
  end
```


## Using GenServer.Behaviour
Here, we've cheated a bit.  We just claim to have the item that's attempting to
be taken out of the fridge, without even checking if it's available.  However,
this is sufficient to pass the next test.  In order to pass the final two tests,
we'll need to actually check for the item in the fridge and delete it when we
take it.  Let's implement that.

```elixir
  def handle_call({:take, item}, _from, items) do
    case Enum.member?(items, item) do
      true  -> {:reply, {:ok, item}, items}
      false -> {:reply, :not_found, items}
    end
  end
```


## Using GenServer.Behaviour
That supports the first part of the remaining two tests - replying appropriately
if an item is not found.  The final test hinges on actually removing the taken
item from the fridge.  Implementing that:

```elixir
  def handle_call({:take, item}, _from, items) do
    case Enum.member?(items, item) do
      true  -> {:reply, {:ok, item}, List.delete(items, item)}
      false -> {:reply, :not_found, items}
    end
  end
```


## Prettying up our public interface
Now, looking back at the tests, the interface for this thing is pretty
miserable.  No one wants to be going through the `:gen_server` module directly
to interact with their fridge.  Let's see what a nicer api might look like:

```elixir
{:ok, fridge} = FridgeServer.Server.start_link
:ok = FridgeServer.Server.store(fridge, :bacon)
{:ok, bacon} = FridgeServer.Server.take(fridge, :bacon)
```


## Prettying up our public interface
We'll copy the existing test, and rewrite it to use this interface.

```elixir
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
```


## Prettying up our public interface
Now, to implement this interface we just need to write three simple functions:

```elixir
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
```


## That's it...
That basically gets you started with OTP Servers in Elixir.  If we have time,
I'd like to show Supervision and State Persistence as well...
