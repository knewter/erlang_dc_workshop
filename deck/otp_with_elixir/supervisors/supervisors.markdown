# Supervisors
## Josh Adams

![](https://pbs.twimg.com/profile_images/2284174758/v65oai7fxn47qv9nectx.png)

@knewter


# Supervisors
## Josh Adams
![](https://github.global.ssl.fastly.net/images/modules/logos_page/GitHub-Mark.png)

knewter


# Supervisors
## Josh Adams
[twitters] - @knewter
[githubs]  - /knewter
[work]     - http://isotope11.com
[videos]   - http://elixirsips.com


# Supervisors

Now we're going to talk about a core concept in building systems in the Elixir
Way - "Let it crash."  That is, don't concern youreself with keeping your code
from crashing, just make sure that the system keeps running if something bad
happens.

The way you manage this is by designing your system composed of multiple
processes, managed by supervisors.

## Supervisors

A supervisor exists to manage processes or other supervisors.  There are various
strategies defined in OTP to determine what to do when a child crashes, and
there are ways to handle repeated failures of supervised processes.

Let's look at a project to supervise a ListServer so that it can live through a
crash.

```
mix new supervised_list_server
cd supervised_list_server
```

Let's write a quickie test for the server.  We'll open up
`test/list_server_test.exs`:

```elixir
defmodule ListServerTest do
  use ExUnit.Case

  # Clear the ListServer before each test
  setup do
    ListServer.start_link
    ListServer.clear
  end

  test "it starts out empty" do
    assert ListServer.items == []
  end

  test "it lets us add things to the list" do
    ListServer.add "book"
    assert ListServer.items == ["book"]
  end

  test "it lets us remove things from the list" do
    ListServer.add "book"
    ListServer.add "magazine"
    ListServer.remove "book"
    assert ListServer.items == ["magazine"]
  end
end
```

When we run the tests now, they'll fail because there's no ListServer module.
Let's get started.  We'll open up `lib/list_server.ex` and add a basic
ListServer.  It should all make sense - it's nothing we haven't seen before.

```elixir
defmodule ListServer do
  use GenServer.Behaviour

  ### Public API
  def start_link do
    :gen_server.start_link({:local, :list}, __MODULE__, [], [])
  end

  def clear do
    :gen_server.cast :list, :clear
  end

  def add(item) do
    :gen_server.cast :list, {:add, item}
  end

  def remove(item) do
    :gen_server.cast :list, {:remove, item}
  end

  def items do
    :gen_server.call :list, :items
  end

  ### GenServer API
  def init(list) do
    {:ok, list}
  end

  # Clear the list
  def handle_cast(:clear, list) do
    {:noreply, []}
  end
  def handle_cast({:add, item}, list) do
    {:noreply, list ++ [item]}
  end
  def handle_cast({:remove, item}, list) do
    {:noreply, List.delete(list, item)}
  end

  def handle_call(:items, _from, list) do
    {:reply, list, list}
  end
end
```

Alright, if we run the tests now they'll pass.  Now let's add a misfeature - a
bug.  We'll add a feature whose whole job is to crash the ListServer.  Add the
following:

```elixir
def crash do
  :gen_server.cast :list, :crash
end

#...

def handle_cast(:crash, list) do
  1 = 2
end
```

To verify that this causes a crash, let's open up an `iex` session and see it
happen:

```
iex -S mix
```

Now start a ListServer, add some items, remove some items, list them, and then
cause a crash.  Try to list them after crashing it:


```elixir
ListServer.start_link
ListServer.add "book"
ListServer.items
ListServer.add "cane"
ListServer.items
ListServer.remove "cane"
ListServer.items
ListServer.crash
ListServer.items
```

OK, so once we've crashed, we can't use it any more.  This sucks, because Erlang
and Elixir systems are supposed to be fault-tolerant, and here we made something
crash and it didn't tolerate it.  But of course, that's because we haven't
finished building a proper system.  This is where OTP's supervisors come in.
Let's go ahead and add a supervisor.

Open up `lib/list_supervisor.ex` and add the following:

```elixir
defmodule ListSupervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init(list) do
    child_processes = [ worker(ListServer, list) ]
    supervise child_processes, strategy: :one_for_one
  end
end
```

Now open up `iex -S mix` and try something very similar to what you did before:

```elixir
ListSupervisor.start_link
ListServer.add "book"
ListServer.items
ListServer.add "cane"
ListServer.items
ListServer.remove "cane"
ListServer.items
ListServer.crash
ListServer.items
```

The last item was different - after crashing, we still had a list server!  It
just didn't have the state from before the crash.  This is the essence of
Supervision.  However, the downside here is we really want our actor to keep his
state if he crashes, but that's impossible since it's stored in the process.
The solution to this is to store the actual important bits of state in an
external process and make sure it does very little, so that it cannot crash.


