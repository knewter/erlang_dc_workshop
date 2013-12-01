# GenEvent
## Josh Adams

![](https://pbs.twimg.com/profile_images/2284174758/v65oai7fxn47qv9nectx.png)

@knewter


# GenEvent
## Josh Adams
![](https://github.global.ssl.fastly.net/images/modules/logos_page/GitHub-Mark.png)

knewter


# GenEvent
## Josh Adams

[twitters] - @knewter
[githubs]  - /knewter
[work]     - http://isotope11.com
[videos]   - http://elixirsips.com


# GenEvent

GenEvent is "a behaviour module for implementing event handling functionality."
For this portion of the talk, we're going to see what it would look like to
implement an Entity-Component system like you might use if you were building a
game.  This is basically a port of the `:gen_event` example that Jordan Wilderburg
used at the most recent ErlangCamp, for what it's worth.

## Getting Started

We'll make a new project:

```sh
mix new zeldacat
cd zeldacat
```

We want to start out with a concept of an Entity, and then add a health meter to
our entity.  Go ahead and open up `test/zeldacat_test.exs` and add this:

```elixir
defmodule ZeldacatTest do
  use ExUnit.Case

  test "something with a health component can die" do
    # Create Entity, add health component, then kill it!
    {:ok, entity} = Entity.init()
    Entity.add_component(entity, HealthComponent, 100)
    assert HealthComponent.get_hp(entity) == 100
    assert HealthComponent.alive?(entity) == true
    Entity.notify(entity, {:hit, 50})
    assert HealthComponent.get_hp(entity) == 50
    Entity.notify(entity, {:heal, 25})
    assert HealthComponent.get_hp(entity) == 75
    Entity.notify(entity, {:hit, 75})
    assert HealthComponent.get_hp(entity) == 0
    assert HealthComponent.alive?(entity) == false
  end
end
```

Here we're just asserting that after adding a health component to our entity, we
can:

- Specify the starting HP
- Get the HP
- Reduce HP by hitting the entity
- Increase HP by healing the entity

So that's all good and fine, but how exactly are we going to do this?  This is
where GenEvent comes in.  First, let's start off with an `Entity` module that we
can spawn.  Open up `lib/entity.ex` and add the following:

```elixir
defmodule Entity do
  ### Public API
  def init do
    :gen_event.start_link()
  end
end
```

Here, we're just spawning a process that can be used with GenEvent.  Go ahead
and run the tests.  You'll see we've not yet defined the `add_component/3`
function, so let's go ahead and add that.  It's just a nice wrapper for the
GenEvent api:

```elixir
  def add_component(pid, component, args) do
    :gen_event.add_handler(pid, component, args)
  end
```

This function takes three arguments - a process, a GenEvent.Behaviour to add to
that process, and any arguments that GenEvent takes to its init function.

Run your tests again, and you'll get a new failure, telling you there's no
`HealthComponent.get_hp/1` function defined.  Let's make a new file in
`lib/health_component.ex` to house our first GenEvent.Behaviour:

```elixir
defmodule HealthComponent do
  use GenEvent.Behaviour
end
```

Now, GenEvent's first API we need to satisfy is that it has to respond to an
`init/1` function.  This function should return a tuple whose first element is
`:ok` and whose second element is the initial state for this GenEvent handler.
Each GenEvent (or component, in our terminology) carries its own state within
the process it's attached to.  We expect to just use this to track an entity's
health, and to allow it to be incremented and decremented, so we expect to take
a single argument, `hp`, and return that as our state:

```elixir
  ### GenEvent API
  def init(hp) do
    { :ok, hp }
  end
```

Now we want to attack the missing `get_hp/1` function.  Let's go ahead and
define a function that takes the entity in question as its only argument, and
then sends a synchronous GenEvent call to ask for the state:

```elixir
  ### Public API
  def get_hp(entity) do
    :gen_event.call(entity, HealthComponent, :get_hp)
  end
```

This is just a nice public wrapper around the GenEvent api.  We're sending a
synchronous call that says "hey entity, please send your HealthComponent event
handler the `:get_hp` event synchronously!"

Go ahead and run the tests again, and you'll get an error that says `get_hp`
returned `:ok` instead of `100` - this is because we didn't teach the
HealthComponent how to respond to that event.  Let's go ahead and see what that
looks like.  Add this to the GenEvent API section:

```elixir
  def handle_call(:get_hp, hp) do
    {:ok, hp, hp}
  end
```

Run the tests again, and you'll get to the next line - this means that our
HealthComponent can now return its HP successfully!  The next failure is due to
our not having defined an `alive?/1` function.  This is part of our public API,
so let's go ahead and define it:

```elixir
  def alive?(entity) do
    :gen_event.call(entity, HealthComponent, :alive?)
  end
```

Here, we're just using the same `:gen_event.call` API we used before, but
sending the `alive?` message this time.  If you run the tests now, you'll get a
weird error failure.  This is because the HealthComponent doesn't know how to
respond to that message from the GenEvent API.  We'll add a `handle_call` that
pattern matches that message:

```elixir
  def handle_call(:alive?, hp) do
    {:ok, hp > 0, hp}
  end
```

Once that's done, you've gotten past the next line in our test.  That means you
can now ask both the health of an Entity with the HealthComponent, as well as
whether or not it's still alive.  That's pretty cool, but now our tests fail
because there's no `Entity.notify/2` function defined.  Go ahead and open up
`lib/entity.ex` again and let's define that as a wrapper around
`:gen_event.notify`:

```elixir
  def notify(pid, event) do
    :gen_event.notify(pid, event)
  end
```

This is just a really thin wrapper.  The only reason we add this is because a
user of our system has no need to know that we use `GenEvent` internally.  If
you run the tests now, you'll get an error because the health was supposed to be
50 after we received a hit, but we haven't defined how to handle the `:hit`
asynchronous message, so it has no effect.  Let's go ahead and tell our
HealthComponent how to handle that message:

```elixir
  def handle_event({:hit, amount}, hp) do
    {:ok, hp - amount}
  end
```

If you run the tests now, you get past where they failed before, but once again
you get a really cryptic error.  The underlying problem is that we haven't
defined how to handle the `heal` event for our HealthComponent, so go ahead and
add the following to it:

```elixir
  def handle_event({:heal, amount}, hp) do
    {:ok, hp + amount}
  end
```

Once you've added that, the test completes successfully, and we're done.  This
was just a really quick introduction to GenEvent, and if you go back through the
code you'll find lots of interesting things here - I find it exciting that every
event handler carries its own state around with it inside your process.  I'm not
sure why exactly, but it just seems like a very neat way to define this sort of
thing.

## Resources

- [Erlang Event Driven Applications](http://inaka.net/blog/2013/01/21/erlang-event-driven/)
- [Erlang's `gen_event` Documentation](http://www.erlang.org/doc/man/gen_event.html)
- [Learn You Some Erlang's section on `gen_event`](http://learnyousomeerlang.com/event-handlers)
- [ErlangCentral's article on demystifying `gen_event`](https://erlangcentral.org/wiki/index.php/Gen_event_behavior_demystified)
- [ZeldaCat repo](http://github.com/knewter/zeldacat)
- [jwilderburg's entity manager from ErlangCamp Nashville](https://github.com/erlware/erlang-camp/tree/master/events_and_logs/entity_manager)
